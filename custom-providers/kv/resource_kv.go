package main

import (
	"log"

	"github.com/hashicorp/terraform/helper/schema"
)

func resourceKv() *schema.Resource {
	log.Printf("Initializing resourceKv\n")
	return &schema.Resource{
		Create: resourceKvCreate,
		Read:   resourceKvRead,
		Update: resourceKvUpdate,
		Delete: resourceKvDelete,

		Schema: map[string]*schema.Schema{
			"key": {
				Type:     schema.TypeString,
				Required: true,
			},
			"value": {
				Type:     schema.TypeString,
				Required: true,
			},
		},
	}
}

func resourceKvCreate(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - create\n")
	key := d.Get("key").(string)
	fkv := m.(*FileKV)
	if !fkv.Exists(key) {
		value := d.Get("value").(string)
		_ = fkv.Set(key, value)
	}

	d.SetId(key)
	return resourceKvRead(d, m)
}

func resourceKvRead(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - read\n")
	fkv := m.(*FileKV)
	key := d.Get("key").(string)
	if fkv.Exists(key) {
		_ = d.Set("value", fkv.Get(key))
		return nil
	} else {
		d.SetId("")
		return nil
	}
}

func resourceKvUpdate(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - update\n")
	fkv := m.(*FileKV)
	key := d.Get("key").(string)
	if fkv.Exists(key) {
		val := d.Get("value").(string)
		_ = fkv.Set(key, val)
	}

	return resourceKvRead(d, m)
}

func resourceKvDelete(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - delete\n")
	fkv := m.(*FileKV)
	key := d.Get("key").(string)
	if fkv.Exists(key) {
		_ = fkv.Remove(key)
	}

	return resourceKvRead(d, m)
}
