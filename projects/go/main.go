package main

import (
	"archive/zip"
	"bytes"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
)

func download(url string) []byte {
	getData := func(url string) []byte {
		resp, err := http.Get(url)
		if err != nil {
			log.Fatal(err)
		}
		defer resp.Body.Close()

		data, err := io.ReadAll(resp.Body)
		if err != nil {
			log.Fatal(err)
		}
		return data
	}

	re := regexp.MustCompile("https://download.*.zip")
	data1 := getData(url)
	found := re.FindAllString(string(data1), 1)
	return getData(found[0])
}

func extract(data []byte, path string) {
	reader, err := zip.NewReader(bytes.NewReader(data), int64(len(data)))
	if err != nil {
		log.Fatal(err)
	}

	for _, f := range reader.File {
		fpath := filepath.Join(path, f.Name)

		if f.FileInfo().IsDir() {
			if err := os.MkdirAll(fpath, os.ModePerm); err != nil {
				log.Fatal(err)
			}
			continue
		}

		fnew, err := os.OpenFile(fpath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
		if err != nil {
			log.Fatal(err)
		}
		defer fnew.Close()

		fzip, err := f.Open()
		if err != nil {
			log.Fatal(err)
		}
		defer fzip.Close()

		if _, err := io.Copy(fnew, fzip); err != nil {
			log.Fatal(err)
		}
	}
}

func clean(path string) {
	files, err := os.ReadDir(path)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		if !file.IsDir() && filepath.Ext(file.Name()) == ".jar" {
			err := os.Remove(filepath.Join(path, file.Name()))
			if err != nil {
				log.Fatal(err)
			}
		}
	}
}

func main() {
	if len(os.Args) == 2 {
		clean(getTargetPath())
		println("Downloading...")
		data := download(os.Args[1])
		println("Extracting...")
		extract(data, getTargetPath())
		println("Done.")
	} else {
		println(os.Args[0], "(URL address)")
	}
}
