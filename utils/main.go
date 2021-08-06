package main

import (
	"fmt"
	"log"
	"os"

	"github.com/NethermindEth/warp/utils/seq"
	jsoniter "github.com/json-iterator/go"
	// "sync"
)

func WriteBytecode(path string, bytecode []string) {
	f, err := os.Create(path)
	if err != nil {
		log.Fatalf("failed to create a file in WritePairsData:261 with err: %v\n", err)
	}
	defer f.Close()
	jsonData, err := jsoniter.MarshalIndent(bytecode, "", "    ")
	if err != nil {
		log.Fatalf("failed to create a file in WritePairsData:261 with err: %v\n", err)
	}
	f.Write(jsonData)
	f.Sync()
}

func main() {
	fmt.Println("brrrrrrrr.....")
	addresses := seq.GetAddresses("data/contract_addresses.json")
	var bytecodes []string
	for i := 0; i < 10000; i++ {
		if i == len(addresses.Data) {
			bytecode := seq.GetBytecode(addresses.Data[i])
			bytecodes = append(bytecodes, bytecode)
			break
		}
		bytecode := seq.GetBytecode(addresses.Data[i])
		bytecodes = append(bytecodes, bytecode)
		fmt.Println(i)
	}
	WriteBytecode("data/bytecode.json", bytecodes)
}
