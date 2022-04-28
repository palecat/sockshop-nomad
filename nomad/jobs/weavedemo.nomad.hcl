job "weavedemo" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "10s"
    max_parallel = 1
  }

  group "frontend" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      port "http" {
        static = 80
      }
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "front-end" {
      driver = "docker"

      config {
        image = "weaveworksdemos/front-end:0.3.12"
        hostname = "front-end"
        network_mode = "sockshop-network"
      }

      resources {
        cpu = 100
        memory = 128
      }

      service {
        name = "${TASK}"
        tags = ["frontend", "front-end"]
      }
    }

    task "edge-router" {
      driver = "docker"

      config {
        image = "weaveworksdemos/edge-router:0.1.1"
        hostname = "edge-router"
        ports = ["http"]
        network_mode = "sockshop-network"
      }

      service {
        name = "${TASK}"
        tags = ["router", "edgerouter"]
      }

      resources {
        cpu = 100
        memory = 128
      }
    }
  }

  group "catalogue" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "catalogue" {
      driver = "docker"

      config {
        image = "weaveworksdemos/catalogue:0.3.5"
        hostname = "catalogue"
        network_mode = "sockshop-network"
      }

      env {
        MYSQL_DATABASE = "socksdb"
        MYSQL_ROOT_PASSWORD = "fake_password"
      }

      service {
        name = "${TASK}"
        tags = ["catalogue"]
      }

      resources {
        cpu = 100
        memory = 128
      }
    }

    task "catalogue-db" {
      driver = "docker"

      config {
        image = "weaveworksdemos/catalogue-db:0.3.0"
        hostname = "catalogue-db"
        network_mode = "sockshop-network"
      }

      env {
        MYSQL_DATABASE = "socksdb"
        MYSQL_ROOT_PASSWORD = "fake_password"
      }

      service {
        name = "${TASK}"
        tags = ["db", "catalogue", "cataloguedb"]
      }

      resources {
        cpu = 100
        memory = 700
      }
    }
  }

  group "carts" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "carts" {
      driver = "docker"

      config {
        image = "weaveworksdemos/carts:0.4.8"
        hostname = "carts"
        network_mode = "sockshop-network"
      }

      service {
        name = "${TASK}"
        tags = ["carts"]
      }

      resources {
        cpu = 100
        memory = 1024
      }
    }

    task "carts-db" {
      driver = "docker"

      config {
        image = "mongo:3.4"
        hostname = "carts-db"
      }

      service {
        name = "${TASK}"
        tags = ["db", "cart", "cartdb"]
      }

      resources {
        cpu = 100
        memory = 128
      }
    }
  }

  group "shipping" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "shipping" {
      driver = "docker"

      config {
        image = "weaveworksdemos/shipping:0.4.8"
        hostname = "shipping"
        network_mode = "sockshop-network"
      }

      service {
        name = "${TASK}"
        tags = ["shipping"]
      }

      resources {
        cpu = 100
        memory = 1024
      }
    }
  }

  group "payment" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "payment" {
      driver = "docker"

      config {
        image = "weaveworksdemos/payment:0.4.3"
        hostname = "payment"
        network_mode = "sockshop-network"
      }

      service {
        name = "${TASK}"
        tags = ["payment"]
      }

      resources {
        cpu = 100
        memory = 16
      }
    }
  }

  group "orders" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "orders" {
      driver = "docker"

      config {
        image = "weaveworksdemos/orders:0.4.7"
        hostname = "orders"
        network_mode = "sockshop-network"
      }

      service {
        name = "${TASK}"
        tags = ["orders"]
      }

      resources {
        cpu = 100
        memory = 1024
      }
    }

    task "orders-db" {
      driver = "docker"

      config {
        image = "mongo"
        hostname = "orders-db"
        network_mode = "sockshop-network"
      }

      service {
        name = "${TASK}"
        tags = ["db", "orders", "ordersdb"]
      }

      resources {
        cpu = 100
        memory = 64
      }
    }
  }

  group "queue-master" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "queue-master" {
      driver = "docker"

      config {
        image = "weaveworksdemos/queue-master:0.3.1"
        hostname = "queue-master"
        network_mode = "sockshop-network"
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
        ]
      }

      service {
        name = "${TASK}"
        tags = ["queuemaster"]
      }

      resources {
        cpu = 100
        memory = 800
      }
    }
  }

  group "rabbitmq" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      dns {
        servers = ["172.17.0.1"]
        searches = ["service.consul"]
      }
    }

    task "rabbitmq" {
      driver = "docker"

      config {
        image = "rabbitmq:3.6.8"
        hostname = "rabbitmq"
        network_mode = "sockshop-network"
      }

      service {
        name = "${TASK}"
        tags = ["db"]
      }

      resources {
        cpu = 100
        memory = 250
      }
    }
  }
}
