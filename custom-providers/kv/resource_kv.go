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
			"key": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
			"value": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
		},
	}
}

func resourceKvCreate(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - create")
	key := d.Get("key").(string)
	fkv := m.(*FileKV)
	if !fkv.Exists(key) {
		value := d.Get("value").(string)
		fkv.Set(key, value)
	}

	d.SetId(key)
	return resourceKvRead(d, m)
}

func resourceKvRead(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - read")
	fkv := m.(*FileKV)
	key := d.Get("key").(string)
	if fkv.Exists(key) {
		d.Set("value", fkv.Get(key))
		return nil
	} else {
		d.SetId("")
		return nil
	}
}

func resourceKvUpdate(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - update")
	fkv := m.(*FileKV)
	key := d.Get("key").(string)
	if fkv.Exists(key) {
		val := d.Get("value").(string)
		fkv.Set(key, val)
	}

	return resourceKvRead(d, m)
}

func resourceKvDelete(d *schema.ResourceData, m interface{}) error {
	log.Printf("resourceKv - delete")
	fkv := m.(*FileKV)
	key := d.Get("key").(string)
	if fkv.Exists(key) {
		fkv.Remove(key)
	}

	return resourceKvRead(d, m)
}
