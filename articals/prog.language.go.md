# Golang {docsify-ignore}

### gRPC服务

#### 配置环境
* 安装编译器(protoc)

    点击[protoc](https://github.com/protocolbuffers/protobuf/releases/)进入下载页面，我这里采用的是[protoc-3.20.1-rc-1-win64.zip](https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1-rc1/protoc-3.20.1-rc-1-win64.zip)
    解压之后，将其中 `bin\protoc.exe` 拷贝到 `GOPATH\bin` 下，我本地是 `E:\MonkeyCode\space.go\bin`，可在终端输入`protoc --version`查看版本 `libprotoc 3.20.1-rc1`

* 安装插件(protoc-gen-go和protoc-gen-go-grpc)
    
    * 终端运行 `go install google.golang.org/protobuf/cmd/protoc-gen-go@latest`，这个需要Golang的版本不低于1.16，运行完之后，就可以在 `GOPATH\bin` 下看到 `protoc-gen-go.exe`

    * 终端运行 `go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest`，这个需要Golang的版本不低于1.16，运行完之后，就可以在 `GOPATH\bin` 下看到 `protoc-gen-go-grpc.exe`

至此，环境算是配置好了，接下来，看一个简单例子吧

#### 示例Hello
  
* 定义`protoc\hello.proto`
  ```protobuf
  syntax = "proto3";

  // .代表在当前目录生成 hello表示生成的包名
  option go_package = ".;hello";
  
  message HelloResponse {
    string responseSomething = 1;
  }
  
  message HelloRequest {
    string saySomething = 1;
  }
  
  service HelloService {
    rpc Say(HelloRequest) returns (HelloResponse) {}
  }
  ```
  
  然后分别执行 `protoc --go_out=. hello.proto` 和 `protoc --go-grpc_out=. hello.proto`，生成 `hello.pb.go` 和 `hello_grpc.pb.go` 两个文件。
  如果出现有依赖未找到的，可执行 `go mod tidy`。

* 服务端`server\server.go`
  ```go
  package main

  import (
    "context"
    world "go.test/hello/proto"
    "net"
    "google.golang.org/grpc"
    "log"
  )
  
  type HelloWorld struct {
    world.UnimplementedWorldServer
    h *world.WorldServer
  }
  
  func (h *HelloWorld) MustEmbedUnimplementedWorldServer() {
    panic("implement me")
  }
  
  func (h *HelloWorld) Say(ctx context.Context, req *world.WorldRequest) (*world.WorldResponse, error) {
    log.Println("receive message:", req.GetSaySomething())
    resp := &world.WorldResponse{}
    resp.ResponseSomething = "roger that!"
    return resp, nil
  }
  
  func main() {
    srv := grpc.NewServer()
    world.RegisterWorldServer(srv, &HelloWorld{})
  
    listener, err := net.Listen("tcp", ":12345")
    if err != nil {
      log.Fatalf("failed to listen: %v", err)
    }
  
    err = srv.Serve(listener)
    if err != nil {
      log.Fatalf("failed to serve: %v", err)
    }
  }
  ```
  
* 客户端`client\client.go`
  ```go
  package main

  import (
    "context"
    world "go.test/hello/proto"
    "net"
    "google.golang.org/grpc"
    "log"
  )
  
  type HelloWorld struct {
    world.UnimplementedWorldServer
    h *world.WorldServer
  }
  
  func (h *HelloWorld) MustEmbedUnimplementedWorldServer() {
    panic("implement me")
  }
  
  func (h *HelloWorld) Say(ctx context.Context, req *world.WorldRequest) (*world.WorldResponse, error) {
    log.Println("receive message:", req.GetSaySomething())
    resp := &world.WorldResponse{}
    resp.ResponseSomething = "roger that!"
    return resp, nil
  }
  
  func main() {
    srv := grpc.NewServer()
    world.RegisterWorldServer(srv, &HelloWorld{})
  
    listener, err := net.Listen("tcp", ":12345")
    if err != nil {
      log.Fatalf("failed to listen: %v", err)
    }
  
    err = srv.Serve(listener)
    if err != nil {
      log.Fatalf("failed to serve: %v", err)
    }
  }
  ```
  
* 参考链接
  * [Protocol Buffer Basics: Go](https://developers.google.cn/protocol-buffers/docs/gotutorial) 
  * [gRPC-go 入门（1）：Hello World](https://blog.csdn.net/inet_ygssoftware/article/details/117608527)
  * [golang Grpc 中出现 it has a non-exported method and is defined in a different package](https://www.jianshu.com/p/d2c8fdd24b0f)

#### 相关站点
  * 暂无