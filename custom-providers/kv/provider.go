package main

import (
	"log"

	"github.com/hashicorp/terraform/helper/schema"
)

func Provider() *schema.Provider {
	log.Printf("Initializing provider\n")
	return &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			"kv": resourceKv(),
		},
		ConfigureFunc: providerConfigure,
	}
}

func providerConfigure(d *schema.ResourceData) (interface{}, error) {
	return NewFileKV(), nil
}
