package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
)

var fileName = "kvStore"

type FileKV struct {
	kvMap map[string]string
}

func NewFileKV() *FileKV {
	fkv := new(FileKV)
	data, err := ioutil.ReadFile(fileName)
	if err != nil {
		fkv.kvMap = make(map[string]string)
		empty, _ := json.Marshal(make(map[string]string))
		_, _ = os.Create(fileName)
		_ = ioutil.WriteFile(fileName, empty, 0644)
		return fkv
	}

	_ = json.Unmarshal(data, &fkv.kvMap)
	return fkv
}

func (fkv *FileKV) Exists(key string) bool {
	_, exists := fkv.kvMap[key]
	return exists
}
func (fkv *FileKV) Set(key string, value string) error {
	log.Printf("fkv: %v", fkv.kvMap)
	fkv.kvMap[key] = value

	return fkv.save()
}

func (fkv *FileKV) Get(key string) string {
	return fkv.kvMap[key]
}

func (fkv *FileKV) Remove(key string) error {
	delete(fkv.kvMap, key)
	return fkv.save()
}

func (fkv *FileKV) save() error {
	data, _ := json.Marshal(fkv.kvMap)
	return ioutil.WriteFile(fileName, data, 0644)
}
