package main

// fmt is short for format (formatted I/O).
import (
	"fmt"
	"log"
	"context"
	"bytes"
    "encoding/json"
    "net/http"
    "github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
	// format.PrintLine
	fmt.Println("Hello, world!")
}

type Config struct {
	Endpoint string
	Token string
	UserUuid string 
  }

// in golang, a titlecase function will get exported
func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap:   map[string]*schema.Resource{
			"terratowns_home": Resource(),
		},
		DataSourcesMap: map[string]*schema.Resource{},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The endpoint for the external service",
			},
			"token": {
				Type:        schema.TypeString,
				Sensitive:   true, //mar value as sensitive to hide it the logs
				Required:    true,
				Description: "Bearer token for authorization",
			},
			"user_uuid": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "UUID for configuration",
			},
		},
	}
	//p.ConfigureContextFunc = providerConfigure(p)
	return p
}

func validateUUID(v interface{}, k string) (ws []string, errors []error) {
	log.Print("validateUUID:start")
	value := v.(string)
	if _, err := uuid.Parse(value); err != nil {
		errors = append(errors, fmt.Errorf("invalid UUID format"))
	}
	log.Print("validateUUID:end")
  return
}

func providerConfigure(p *schema.Provider) schema.ConfigureContextFunc {
  return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics ) {
	log.Print("providerConfigure:start") 
	config := Config{
	  Endpoint: d.Get("endpoint").(string),
	  Token: d.Get("token").(string),
	  UserUuid: d.Get("user_uuid").(string),
	}
	log.Print("providerConfigure:end")
	return &config, nil
  }
}

func Resource() *schema.Resource {
   log.Print("Resource:start")
   resource := &schema.Resource{
     CreateContext: resourceHouseCreate,
     ReadContext: resourceHouseRead,
     UpdateContext: resourceHouseUpdate,
     DeleteContext: resourceHouseDelete,
     //new code for this section
     Schema: map[string]*schema.Schema{
  	 "name": {
  	   Type: schema.TypeString,
  	   Required: true,
  	 },
  	 "description": {
  	   Type: schema.TypeString,
  	   Required: true,
  	   Description: "Decription of home",
  	 },
  	 "domain_name": {
  	   Type: schema.TypeString,
  	   Required: true,
  	   Description: "Domain name of home eg. *.cloudfront.net",
  	 },
  	 "town": {
  	   Type: schema.TypeString,
  	   Required: true,
  	   Description: "Town name",
  	 },
  	 "content_version": {
  	   Type: schema.TypeInt,
  	   Required: true,
  	   Description: "content_version",
  	 },
  },
}  
log.Print("Resource:start")
return resource

}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  log.Print("ResourceHouseCreate:start")
  var diags diag.Diagnostics
	
  config := m.(*Config)
	
  // New payload config
  payload := map[string]interface{}{
    "name": d.Get("name").(string),
    "description": d.Get("description").(string),
    "domain_name": d.Get("domain_name").(string),
    "town": d.Get("town").(string),
    "content_version": d.Get("content_version").(int),
  }
  
  // Convert the payload in bytes using a json function
  payloadBytes, err := json.Marshal(payload)
  if err != nil {
    return diag.FromErr(err)
  }

  url := config.Endpoint+"/u/"+config.UserUuid+"/home"
  log.Print("URL: "+url)
  // New construct the HTTP request
  req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
  if err != nil {
    return diag.FromErr(err)
  }
  
  // Set Headers
  req.Header.Set("Authorization", "Bearer "+config.Token)
  req.Header.Set("Content-Type", "application/json")
  req.Header.Set("Accept", "application/json")
  
  client := http.Client{}
  resp, err := client.Do(req)
  if err != nil {
    return diag.FromErr(err)
  }
  defer resp.Body.Close()
  
  var responseData map[string]interface{}
  
  // Parse response json
  if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
    return diag.FromErr(err)
  }
  
    // StatusOK=200 HTTP Response Code
  if resp.StatusCode != http.StatusOK {
    return diag.FromErr(fmt.Errorf("failed to create home resource, status_code: %d, status: %s, body %s", resp.StatusCode, resp.Status, responseData))
  } 
  
  // Set the HomeUUID
  homeUUID := responseData["uuid"].(string)  
  d.SetId(homeUUID)
  
  log.Print("resourceHouseCreate:end")

  return diags
  
}
  
func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  log.Print("ResourceHouseRead:start")
  var diags diag.Diagnostics
  
  config := m.(*Config)
  
  homeUUID := d.Id()
  
  url := config.Endpoint+"/u/"+config.UserUuid+"/home/"+homeUUID
  log.Print("URL: "+url)
  // New construct the HTTP request
  req, err := http.NewRequest("GET", url, nil)
  if err != nil {
    return diag.FromErr(err)
  }
  
  // Set Headers
  req.Header.Set("Authorization", "Bearer "+config.Token)
  req.Header.Set("Content-Type", "application/json")
  req.Header.Set("Accept", "application/json")
	
  client := http.Client{}
  resp, err := client.Do(req)
  if err != nil {
    return diag.FromErr(err)
  }
  defer resp.Body.Close()
  
  var responseData map[string]interface{}
  
  // StatusOK=200 HTTP Response Code
  if resp.StatusCode == http.StatusOK {
	  
    // Parse response json (video time stamp 32:05 min)
    if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {    	
		return diag.FromErr(err)
    }
    d.Set("name",responseData["name"].(string))
    d.Set("description",responseData["description"].(string))
    d.Set("domain_name",responseData["domain_name"].(string))
    d.Set("content_version",responseData["content_version"].(float64))
  } else if resp.StatusCode != http.StatusNotFound {
    d.SetId("")
  } else if resp.StatusCode != http.StatusOK {
    return diag.FromErr(fmt.Errorf("failed to read home resource, status_code: %d, status: %s, body %s", resp.StatusCode, resp.Status, responseData))
  } 
	
  log.Print("resourceHouseRead:end")

  return diags
  
}
  
func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  log.Print("ResourceHouseUpdate:start")
  var diags diag.Diagnostics
	
  config := m.(*Config)
	
  homeUUID := d.Id()
	
   // New payload config
  payload := map[string]interface{}{
    "name": d.Get("name").(string),
    "description": d.Get("description").(string),
    "content_version": d.Get("content_version").(int),
  }
	
  // Convert the payload in bytes using a json function
  payloadBytes, err := json.Marshal(payload)
  if err != nil {
    return diag.FromErr(err)
  }
  
  url := config.Endpoint+"/u/"+config.UserUuid+"/home/"+homeUUID
  log.Print("URL: "+url)
  // New construct the HTTP request
  req, err := http.NewRequest("PUT", url, bytes.NewBuffer(payloadBytes))
  if err != nil {
    return diag.FromErr(err)
  }
	
  // Set Headers
  req.Header.Set("Authorization", "Bearer "+config.Token)
  req.Header.Set("Content-Type", "application/json")
  req.Header.Set("Accept", "application/json")
	
  client := http.Client{}
  resp, err := client.Do(req)
  if err != nil {
    return diag.FromErr(err)
  }
  defer resp.Body.Close()
  
   // StatusOK=200 HTTP Response Code
  if resp.StatusCode != http.StatusOK {
    return diag.FromErr(fmt.Errorf("failed to update home resource, status_code: %d, status: %s", resp.StatusCode, resp.Status))
  } 
	
  log.Print("resourceHouseUpdate:end")
	
  // Set the values for the following 
  d.Set("name",payload["name"])
  d.Set("description",payload["description"])
  d.Set("content_version",payload["content_version"])
  return diags
  
}
  
func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  log.Print("ResourceHouseDelete:start")
  var diags diag.Diagnostics
  
  config := m.(*Config)
  
  homeUUID := d.Id()
  
  url := config.Endpoint+"/u/"+config.UserUuid+"/home/"+homeUUID
  log.Print("URL: "+url)
  // New construct the HTTP request
  req, err := http.NewRequest("DELETE", url, nil)
  if err != nil {
    return diag.FromErr(err)
  }
	
  // Set Headers
  req.Header.Set("Authorization", "Bearer "+config.Token)
  req.Header.Set("Content-Type", "application/json")
  req.Header.Set("Accept", "application/json")
  
  client := http.Client{}
  resp, err := client.Do(req)
  if err != nil {
    return diag.FromErr(err)
  }
  defer resp.Body.Close()
  
   // StatusOK=200 HTTP Response Code
  if resp.StatusCode != http.StatusOK {
    return diag.FromErr(fmt.Errorf("failed to delete home resource, status_code: %d, status: %s", resp.StatusCode, resp.Status))
  } 
  
  d.SetId("")
	
  log.Print("resourceHouseDelete:end")

  return diags

}
  