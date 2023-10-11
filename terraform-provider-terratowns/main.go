package main

// fmt is short for format (formatted I/O).
import (
  //"log"
  "fmt"
  "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
  "github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main () {
  plugin.Serve(&plugin.ServeOpts{
    ProviderFunc: Provider,
  })
  // format.PrintLine 
  fmt.Println("Hello, world!")
}

// in golang, a titlecase function will get exported
func Provider() *schema.Provider {
  var p *schema.Provider
  p = &schema.Provider{
    ResourcesMap: map[string]*schema.Resource{
    
    },
    DataSourcesMap: map[string]*schema.Resource{
    
    },
    Schema: map[string]*schema.Schema{
      "endpoint": {
        Type: schema.TypeString,
        Required: true,
        Description: "The endpoint for the external service",
      },
      "token": {
        Type: schema.TypeString,
        Sensitive: true, //mar value as sensitive to hide it the logs
        Required: true,
        Description: "Bearer token for authorization",
      },
      "user_uuid": {
        Type: schema.TypeString,
        Required: true,
        Description: "UUID for configuration",
      },
    },
  }  
  //p.ConfigureContextFunc = providerConfigure(p)
  return p
}

