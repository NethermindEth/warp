package grt

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"

	jsoniter "github.com/json-iterator/go"
)

var json = jsoniter.ConfigFastest

const g_GRTUniV2 string = "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2"

func GetPairCount() int {
	jsonData := map[string]string{"query": `{ 
		uniswapFactory(id: "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f") {
			pairCount
		}
	}`}
	jsonValue, _ := jsoniter.ConfigFastest.Marshal(jsonData)
	resp, err := http.Post(g_GRTUniV2, "application/json", bytes.NewBuffer(jsonValue))
	if err != nil {
		fmt.Println("IN ERROR")
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	bodyBytes, _ := ioutil.ReadAll(resp.Body)
	fmt.Println(string(bodyBytes))
	pairCount, _ := strconv.Atoi(json.Get(bodyBytes, "data", "uniswapFactory", "pairCount").ToString())
	return pairCount
}

func QueryAllPairs() []string {
	// Maps pair address to pair data
	var addresses []string
	totalPairs := GetPairCount()
	remainingPairs := totalPairs
	firstStep := true
	var pairs []string
	var lastID string
	for {
		if firstStep {
			firstStep = false
			jsonData := map[string]string{"query": `{ 
			pairs(first: 1000) {
			    id
				token0 {
					id
				}
				token1 {
					id
				}
			  }
			}`}
			jsonValue, _ := jsoniter.ConfigFastest.Marshal(jsonData)
			resp, err := http.Post(g_GRTUniV2, "application/json", bytes.NewBuffer(jsonValue))
			if err != nil {
				fmt.Println("IN ERROR")
				log.Fatalln(err)
			}
			defer resp.Body.Close()
			bodyBytes, _ := ioutil.ReadAll(resp.Body)
			pairsItr := jsoniter.ConfigFastest.Get(bodyBytes, "data", "pairs")
			remainingPairs -= 1000
			count := 0
			for {
				pairAddr := pairsItr.Get(count, "id").ToString()
				if pairAddr == "" {
					break
				} else {
					pairs = append(pairs, pairAddr)
					tok0Addr := pairsItr.Get(count, "token0", "id").ToString()
					tok1Addr := pairsItr.Get(count, "token1", "id").ToString()
					if tok0Addr == "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2" {
						addresses = append(addresses, tok1Addr)
					} else if tok1Addr == "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2" {
						addresses = append(addresses, tok0Addr)
					} else {
						addresses = append(addresses, tok0Addr, tok1Addr)
					}
				}
				count++
			}
			lastID = pairs[len(pairs)-1]
		} else {
			if remainingPairs < 1000 {
				jsonData := map[string]string{"query": fmt.Sprintf(`{ 
					pairs(first: %v, where: { id_gt: "%v" }) {
						id
						token0 {
							id
						}
						token1 {
							id
						}
					  }
				}`, remainingPairs, lastID)}
				jsonValue, _ := jsoniter.ConfigFastest.Marshal(jsonData)
				resp, err := http.Post(g_GRTUniV2, "application/json", bytes.NewBuffer(jsonValue))
				if err != nil {
					fmt.Println("IN ERROR")
					log.Fatalln(err)
				}
				defer resp.Body.Close()
				bodyBytes, _ := ioutil.ReadAll(resp.Body)
				remainingPairs -= 1000
				fmt.Println("remaining pairs", remainingPairs)
				pairsItr := jsoniter.ConfigFastest.Get(bodyBytes, "data", "pairs")
				count := 0
				for {
					pairAddr := pairsItr.Get(count, "id").ToString()
					if pairAddr == "" {
						break
					} else {
						pairs = append(pairs, pairAddr)
						tok0Addr := pairsItr.Get(count, "token0", "id").ToString()
						tok1Addr := pairsItr.Get(count, "token1", "id").ToString()
						if tok0Addr == "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2" {
							addresses = append(addresses, tok1Addr)
						} else if tok1Addr == "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2" {
							addresses = append(addresses, tok0Addr)
						} else {
							addresses = append(addresses, tok0Addr, tok1Addr)
						}
					}
					count++
				}
				break
			}
			jsonData := map[string]string{"query": fmt.Sprintf(`{ 
			pairs(first: 1000, where: { id_gt: "%v" }) {
			    id
				token0 {
					id
				}
				token1 {
					id
				}
			  }
			}`, lastID)}
			jsonValue, _ := jsoniter.ConfigFastest.Marshal(jsonData)
			resp, err := http.Post(g_GRTUniV2, "application/json", bytes.NewBuffer(jsonValue))
			if err != nil {
				fmt.Println("IN ERROR")
				log.Fatalln(err)
			}
			defer resp.Body.Close()
			bodyBytes, _ := ioutil.ReadAll(resp.Body)
			remainingPairs -= 1000
			fmt.Println("remaining pairs", remainingPairs)
			pairsItr := jsoniter.ConfigFastest.Get(bodyBytes, "data", "pairs")
			count := 0
			for {
				pairAddr := pairsItr.Get(count, "id").ToString()
				if pairAddr == "" {
					break
				} else {
					pairs = append(pairs, pairAddr)
					tok0Addr := pairsItr.Get(count, "token0", "id").ToString()
					tok1Addr := pairsItr.Get(count, "token1", "id").ToString()
					if tok0Addr == "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2" {
						addresses = append(addresses, tok1Addr)
					} else if tok1Addr == "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2" {
						addresses = append(addresses, tok0Addr)
					} else {
						addresses = append(addresses, tok0Addr, tok1Addr)
					}
				}
				count++
			}
			lastID = pairs[len(pairs)-1]
			fmt.Printf("LASTID: %v\n", lastID)
			fmt.Println(len(pairs))
		}
	}
	return addresses
}

func WriteAddresses(path string) []string {
	addresses := QueryAllPairs()
	f, err := os.Create(path)
	defer f.Close()
	if err != nil {
		fmt.Printf("failed to create a file in WritePairsData:261 with err: %v\n", err)
		return []string{}
	}
	f.WriteString(`{"data": [`)
	f.Sync()
	for i := 0; i < len(addresses); i++ {
		if i == len(addresses) {
			toWrite := fmt.Sprintf(`"%v"`, addresses[i])
			f.WriteString(toWrite)
			f.Sync()

		}
		toWrite := fmt.Sprintf(`"%v", `, addresses[i])
		f.WriteString(toWrite)
		f.Sync()
	}
	f.WriteString("]}")
	f.Sync()
	return addresses
}
