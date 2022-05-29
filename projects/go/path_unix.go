//go:build !windows
// +build !windows

package main

import (
	"log"
	"os"
	"path/filepath"
)

func getTargetPath() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatal(err)
	}
	return filepath.Join(homeDir, ".minecraft/mods")
}
