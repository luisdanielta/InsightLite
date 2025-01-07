# Metapocket: Bridging Pocketbase and Metabase

**Metapocket** is a seamless integration of the lightweight power of Pocketbase, a SQLite-backed server, with Metabase, a robust data visualization and analytics tool. This project enables effortless exploration and analysis of your data in a sleek, unified setup.

## Key Features

- **Data Persistence**: Ensures your data is securely stored in a shared volume.
- **Custom Network Configuration**: Utilizes isolated Docker networks for a secure and organized setup.
- **Health Monitoring**: Includes a built-in health check for Metabase to ensure system reliability.

## Prerequisites
1. Create a custom network for better organization and security:

   ```bash
   docker network create --driver=bridge --subnet=192.168.2.0/24 metapocket_net
   ```

## Getting Started

### Step 1: Deploy the Services

1. Start the services:

   ```bash
   docker-compose up -d
   ```

2. Access the web interfaces:
   - **Pocketbase**: [http://localhost:3081](http://localhost:3081)
   - **Metabase**: [http://localhost:3080](http://localhost:3080)

## How It Works

### Pocketbase

- Acts as a lightweight backend server with SQLite storage.
- Stores data in the `/pb_data` directory.
- Primary database file: `data.db`.

### Metabase

- Connects to Pocketbase by utilizing the SQLite database it creates. Configure Metabase to use the path `/pb_data/data.db` as the data source for seamless integration and visualization.
- Empowers you to create dashboards, answer business questions, and generate reports.
- Configured with a health check to ensure continuous uptime.

## Best Practices

- **Use a Custom Network**: Isolate your services for enhanced security and organization.
- **Back Up Regularly**: Safeguard the `metapocket_data` volume to prevent data loss.
- **Monitor Health**: Leverage Metabase's health endpoint to keep track of system status.

## Additional Resources

- [Pocketbase Documentation](https://pocketbase.io/docs/)
- [Metabase Documentation](https://www.metabase.com/docs/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

---

Discover the power of combining Pocketbase and Metabase with Metapocket. It's simple, efficient, and incredibly effective!
