package seq

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	jsoniter "github.com/json-iterator/go"
)

type Addresses struct {
	Data []string `json:"data"`
}

var json = jsoniter.ConfigFastest

func WriteBytecode(bytecode []string) {
	jsonData, err := json.MarshalIndent(bytecode, "", "    ")
	if err != nil {
		log.Fatalf("Failed to marshal bytecode: %s", err)
	}
	f, err := os.Create("data/bytecode.json")
	if err != nil {
		log.Fatalf("failed to create a file in WritePairsData:261 with err: %v\n", err)
	}
	defer f.Close()
	f.Write(jsonData)
	f.Sync()
}

func GetBytecode(address string) string {
	alchemyURL := ""
	payload := fmt.Sprintf(`{"jsonrpc":"2.0","method":"eth_getCode",
					"params":["%v", "latest"],
					"id":1}`, address)
	jsonPayload := []byte(payload)
	req, err := http.NewRequest("POST", alchemyURL, bytes.NewBuffer(jsonPayload))

	if err != nil {
		log.Fatalf("failed toFailed to create new request with err: %v\n", err)
	}

	req.Header.Add("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Fatalf("Failed to send request with err: %v\n", err)
	}

	defer resp.Body.Close()
	bodyBytes, _ := ioutil.ReadAll(resp.Body)
	contractBytecode := json.Get(bodyBytes, "result").ToString()
	// dat, _ := json.Marshal(json.Get(bodyBytes, "result").ToString())
	// fmt.Printf("data/bytecode/bytecode_%v.json\n", nameEnd)
	// f, _ := os.Create(fmt.Sprintf("data/bytecode/bytecode_%v.json", nameEnd))
	// f.Write(dat)
	// f.Close()

	return contractBytecode
}

func GetAddresses(path string) Addresses {
	file, err := os.Open(path)
	if err != nil {
		log.Fatalf("Failed to open file with err: %v", err)
	}
	defer file.Close()

	bytes, _ := ioutil.ReadAll(file)
	var addresses Addresses
	json.Unmarshal(bytes, &addresses)
	return addresses
}
