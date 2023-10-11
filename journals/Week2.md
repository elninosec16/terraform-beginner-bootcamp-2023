# Terraform Beginner Bootcamp 2023

## Week 2 Project Diagram 

![Week 2 Project Diagram](/pics/Week1.png)

## Week 2 - Table of Contents

3. Configure GitPod to install `Sinatra` for Ruby:
 #[Sinratra in Ruby Web Applications Server](https://sinatrarb.com/)

### Sinatra

Sinatra is a free and open source software web application library and domain-specific language written in Ruby.

[Sinatra](https://sinatrarb.com/)

### Running the Sinatra Web Server

```rb
bundle install
bundle exec ruby server.rb
```
> All the code for the Sinatra Web Server is setup on the `server.rb` file.


### Bundler
 
 It a Ruby package manager 
 
#### Install Gems
 
 ```rb
# frozen_string_literal: true

source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
 ```  
 
 To install the package on the `Gemsfile` you need to run `bundle install` command
 
 The `GemsFile.lock` will be installed after the packages installation to lock down the Gems version being used.
 
#### Execute `Ruby` scripts
 
The `bundle exec` is used to run future `Ruby` scripts.
 
#### `Ruby` ActiveModel

[Active Model Basics](https://guides.rubyonrails.org/active_model_basics.html)

#### `Ruby` Active Record Validations

[Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)

#### Bearer Authentication Token

It's also called `Token Authentication`

[Bearer Authentication](https://swagger.io/docs/specification/authentication/bearer-authentication/)
 

### Terraform Terratowns Provider
1. Create a new foler inside terraform project call
`terraform-provider-terratowns`

2. Perform the first `main.go` file code
```go
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

```

3. Create a new `.terraformrc` file

```go
provider_installation {
  filesystem_mirror {
    path = "/home/gitpod/.terraform.d/plugins"
    include ["local.providers/*/*"]
  }
  direct {
    exclude = ["local.providers/*/*"]
  }
}
```

4. New `build_provider` file on the `bin` folder
```bash
#! /usr/bin/bash

PLUGIN_DIR="~/.terraform.d/plugins/local.providers/local/terratowns/1.0.0/"
PLUGIN_NAME="terraform-provider-terratowns_v1.0.0"

cd $PROJECT_ROOT/terraform-provider-terratowns
cp $PROJECT_ROOT/terraformrc /home/gitpod.terraformrc
rm -rf ~/.terraform.d/plugins
rm -rf $PROJECT_ROOT/.terraform
rm -rf $PROJECT_ROOT/.terraform.lock.hcl
go build -o $PLUGIN_NAME
mkrdir -p $PLUGIN_DIR/x86_64/
mkrdir -p $PLUGIN_DIR/linux_amd64/
cp $PLUGIN_NAME $PLUGIN_DIR/x86_64
cp $PLUGIN_NAME $PLUGIN_DIR/linux_amd64
```

5. New `go.mod` file in the `terraform-provider-terratowns` folder
```go
module github.com/ExamProCo/terraform-provider-terratowns

go 1.20

replace github.com/ExamProCo/terraform-provider-terratowns => /workspace/terraform-beginner-bootcamp-2023/terraform-provider-terratowns
```

6. Ignore the `terraform-provider-terratowns_v1.0.0` to be pushed to Github on the `.gitignore` file

```tf
terraform-provider-terratowns/terraform-provider-terratowns_v*
```

### TF Provider Resource Skeleton

1. Test validation function
```go
func validateUUID(v interface{}, k string) (ws []string, errors []error) {
  log.Print("validateUUID:start")
  value := v.(string)
  if _,err := uuid.Parse(value); err != nil {
    errors = append(error, fmt.Errorf("invalid UUID format"))
  }
  log.Print("validateUUID:end")
}
```
2. Run the `build_provider` bash script
```bash
./bin/build_provider
```
3. Add `Go` as VS Code extension 
```yml
- golang.go
```

4. Missing `uuid` import
```go
"github.com/google/uuid"
```
> after imported it, be sure to be on the `main.go` module in order to install it.
```go
go get github.com/ExamProCo/terraform-provider-terratowns
```

5. Build a new code block for `providerConfigure()` function
```go
func providerConfigure(p *schema.Provider) schema.ConfigureConectextFunc {
  return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostic ) {
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
```

6. Import missing `Go` libraries
```go
"context"
"github.com/hasicorp/terraform plugin sdk/v2/diag"
```

7. Define missing config structure
```go
type Config struct {
  Endpoint string
  Token string
  UserUuid string 
}
```

8. Create a new resource code block
```go
//copy code on the Resource section
func Provider() *schema.Provider {
  ResourcesMap: map[string]*schema.Resource{
    "terratowns_home": Resource(),
  },
}


//copy this code at the end of the code block
func Resource() *schema.Resource {
  log.Print("Resource:start")
  resource := &schema.Resource{
    CreateContext: resourceHouseCreate,
    ReadContext: resourceHouseRead,
    UpdateContext: resourceHouseUpdate,
    DeleteContext: resourceHouseDelete,
  }
  log.Print("Resource:start")
  return resource
}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  var diags diag.Diagnostics
  return diags

}

func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  var diags diag.Diagnostics
  return diags

}

func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  var diags diag.Diagnostics
  return diags

}

func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  var diags diag.Diagnostics
  return diags

}

```

## CRUD

It stands for Create, Read, Update and Delete

(Create, read, update and delete)[https://en.wikipedia.org/wiki/Create,_read,_update_and_delete]


## Support Links:

[^1]:[Terraform Local Providers and Registry Mirror Configuration](https://servian.dev/terraform-local-providers-and-registry-mirror-configuration-b963117dfffa)

[^2]:[Create, read, update and delete](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)

