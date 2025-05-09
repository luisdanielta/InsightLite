# InsightLite: Connect and Analyze

**InsightLite** is a lightweight, Docker-based framework designed to help developers and data engineers connect multiple existing SQLite databases—such as those from Pi-hole, Home Assistant, or any embedded app—to Metabase, a powerful data visualization and analytics tool.

## Key Features

- **Multi-Tenant Support**: Run multiple Pocketbase instances simultaneously on a shared volume, each isolated per customer or context.
- **Data Persistence**: Stores data securely using a Docker-managed volume, with per-customer subdirectories.
- **Custom Network Configuration**: Uses a dedicated Docker bridge network for secure inter-service communication.
- **Health Monitoring**: Includes a health check endpoint for Metabase to ensure operational reliability.

![Arch](./public/arch.svg)

### Label

| Element         | Description                          |
|----------------|--------------------------------------|
| `metapocket_ui`| UI container (Metabase)              |
| `metapocket_01/02` | Customer-specific server containers |
| `metapocket_data` | Shared volume mounted at `/data`     |
| `metabase_net`  | Network used for inter-container communication |

## Getting Started

### Step 1: Deploy the Services

1. Launch the services:

   ```bash
   docker-compose up -d
   ```

2. Access the interfaces:
   - **Metabase UI**: http://localhost:3080
   - **Pocketbase (example)**: http://localhost:3081

> Note: You can define multiple Pocketbase instances by duplicating the service block with new `container_name`, `DATA_DIR`, and `port`.

### Example: Defining Multiple Pocketbase Servers

```yaml
  metabase_server_customerA:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: metapocket_server_customerA
    ports:
      - 3081:8090
    environment:
      - DATA_DIR=/data/customerA
    volumes:
      - metapocket_data:/data
    restart: unless-stopped
    networks:
      - metabase_net

  metabase_server_customerB:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: metapocket_server_customerB
    ports:
      - 3082:8090
    environment:
      - DATA_DIR=/data/customerB
    volumes:
      - metapocket_data:/data
    restart: unless-stopped
    networks:
      - metabase_net
```

Each server runs Pocketbase serving data from its own directory inside the same volume.

### Metabase Configuration for Multiple Sources

You can connect Metabase to each Pocketbase database by creating a **new SQLite data source** for each:

1. Go to **Admin > Databases > Add a Database**
2. Select **SQLite**
3. Set the path to the corresponding file inside the container:
   - Example: `/data/customerA/data.db`
   - Another: `/data/customerB/data.db`
4. Repeat for each customer or dataset

This enables you to explore and analyze datasets from multiple isolated Pocketbase instances in one unified Metabase dashboard.

## How It Works

### Pocketbase

- Pocketbase runs in serve mode using a custom entrypoint:
  
  ```sh
  #!/bin/sh
  exec pocketbase serve --dir "${DATA_DIR}" --http "0.0.0.0:8090"
  ```

- `DATA_DIR` is injected via environment variables and points to a subfolder inside a shared Docker volume.
- This allows multi-tenant data isolation with shared infrastructure.

### Metabase

- Runs on `localhost:3080`
- Automatically discovers SQLite files via explicit paths in container volume
- Can connect to multiple `.db` files concurrently
- Includes a health check:

  ```yaml
  healthcheck:
    test: curl --fail -I http://localhost:3000/api/health || exit 1
    interval: 15s
    timeout: 5s
    retries: 5
  ```

## Best Practices

- **Organize by Customer**: Use `/data/<customer>` directory names to maintain clean separation.
- **Monitor Usage**: Monitor Pocketbase endpoints and Metabase queries independently.
- **Secure Ports**: Avoid exposing Pocketbase instances externally unless necessary.
- **Back Up Smartly**: Back up the volume (`metapocket_data`) and/or each customer’s `.db` file independently.
- **Use Docker Volumes**: This improves portability and isolation.

## Additional Resources

- https://pocketbase.io/docs/
- https://www.metabase.com/docs/
- https://docs.docker.com/compose/compose-file/

---

Discover the power of combining Pocketbase and Metabase with **Metapocket**. Now with native support for multi-tenant deployments, your data workflows just got massively more scalable.
