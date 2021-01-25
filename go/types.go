package main

type Product struct {
	Sku        int       `json:"sku"`
	Name     string    `json:"name"`
	Type      string    `json:"type"`
	Price float32 `json:"price"`
	Upc    string    `json:"upc"`
	Categories []Category `json:"category"`
	Shipping interface{} `json:"shipping"`
	Description string `json:"description"`
	Manufacturer string `json:"manufacturer"`
	Model string `json:"model"`
	Url string `json:"url"`
	Image string `jons:"image"`
}

type Category struct {
	Id string `json:"id"`
	Name  string `json:"name"`
}
