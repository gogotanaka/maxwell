package main

import (
	"encoding/json"
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"io/ioutil"
	"os"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Basis struct {
	title              string
	market             string
	industry           string
	price_limit        string
	capitalization     string
	shares_outstanding string
	dividend_yield     string
	minimum_purchase   string
	share_unit         string
	yearly_high        string
	yearly_low         string
}

type Margin struct {
	margin_buying    string
	d_margin_buying  string
	margin_rate      string
	margin_selling   string
	d_margin_selling string
}

type Index struct {
	price          string
	previousprice  string
	opening        string
	high           string
	low            string
	turnover       string
	trading_volume string
	dps            string
	per            string
	pbr            string
	eps            string
	bps            string
}

func getPage(code string, f *os.File) {
	var url string = fmt.Sprintf("http://stocks.finance.yahoo.co.jp/stocks/detail/?code=%s", code)
	var b *Basis = &Basis{}
	var i *Index = &Index{}
	var m *Margin = &Margin{}

	doc, _ := goquery.NewDocument(url)

	textMap := func(q string, vars ...*string) {
		for i, v := range vars {
			*v = doc.Find(q).Eq(i).Text()
		}
	}

	b.title = doc.Find("table.stocksTable th.symbol h1").Text()
	b.market = doc.Find("div#ddMarketSelect span.stockMainTabName").Text()
	b.industry = doc.Find("div.stocksDtl dd.category a").Text()
	i.price = doc.Find("table.stocksTable td.stoksPrice").Last().Text()

	textMap("div.innerDate dd strong", &i.previousprice, &i.opening, &i.high, &i.low, &i.turnover, &i.trading_volume, &b.price_limit)
	textMap("div.ymuiDotLine div.yjMS dd.ymuiEditLink strong", &m.margin_buying, &m.d_margin_buying, &m.margin_rate, &m.margin_selling, &m.d_margin_selling)
	textMap("div#main div.main2colR div.chartFinance div.lineFi dl dd strong", &b.capitalization, &b.shares_outstanding, &b.dividend_yield, &i.dps, &i.per, &i.pbr, &i.eps, &i.bps, &b.minimum_purchase, &b.share_unit, &b.yearly_high, &b.yearly_low)

	mapB, _ := json.Marshal(map[string]string{"name": b.title, "price": i.price})
	fmt.Println(string(mapB))

	row := fmt.Sprint(string(mapB), ",")

	_, err := f.WriteString(row)
	check(err)
}

func main() {
	f, err := os.OpenFile("./output.txt", os.O_APPEND|os.O_WRONLY, 0600)
	check(err)
	_, err = f.WriteString("[")
	check(err)

	defer func() {
		f.Close()
		_, err := f.WriteString("]")
		check(err)
	}()

	dat, err := ioutil.ReadFile("./codes")

	var limit = make(chan int, 10)
	for _, code := range strings.Split(string(dat), "\n") {
		go func(code string) {
			limit <- 1
			getPage(code, f)
			<-limit
		}(code)
	}
	select {}
}
