package main

import (
	"errors"
	"fmt"

	"github.com/hashicorp/terraform/helper/schema"
)

var kvMap = make(map[string]string)

func resourceKv() *schema.Resource {
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
	key := d.Get("key").(string)
	value := d.Get("value").(string)
	kvMap[key] = value
	d.SetId(key)
	return resourceKvRead(d, m)
}

func resourceKvRead(d *schema.ResourceData, m interface{}) error {
	key := d.Get("key").(string)
	if value, ok := kvMap[key]; ok {
		d.Set("value", value)
		return nil
	}

	return errors.New(fmt.Sprintf("key %v does not exist", key))
}

func resourceKvUpdate(d *schema.ResourceData, m interface{}) error {
	key := d.Get("key").(string)
	if _, ok := kvMap[key]; ok {
		kvMap[key] = d.Get("value").(string)
	}

	return resourceKvRead(d, m)
}

func resourceKvDelete(d *schema.ResourceData, m interface{}) error {
	key := d.Get("key").(string)
	if _, ok := kvMap[key]; ok {
		delete(kvMap, key)
	}

	return nil
}
