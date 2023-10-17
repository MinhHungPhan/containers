# UCP Security and Role-Based Access Control (RBAC)

Docker's Universal Control Plane (UCP) brings a rich feature set to secure and manage your Docker clusters, and among them stands the role-based access control (RBAC) system. This tutorial will provide a step-by-step guide to understanding and setting up RBAC in UCP.

## Table of Contents

- [Introduction](#introduction)
- [Understanding Role-Based Access Control (RBAC)](#understanding-rbac)
- [Getting Started with RBAC](#getting-started)
- [LDAP Integration](#ldap-integration)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

UCP's robust security features offer a versatile model to manage cluster resources and functionality. In essence, this allows the administrator to grant granular permissions to users, ensuring they have access only to the necessary resources or services within the Docker Enterprise infrastructure.

## Understanding Role-Based Access Control (RBAC)

At the heart of UCP's security features is the RBAC system. This breaks down into several key components:
- **User**: An authenticated individual. 
- **Team**: A group of users sharing permissions.
- **Organizations (Orgs)**: Groups of teams. It provides another layer of hierarchy in user management.
- **Service Accounts**: Kubernetes specific objects that grant containers access to cluster resources.
- **Subject**: Refers to the entity (user, team, org, or service account) receiving access.
- **Resource Set**: A collection of resources, like Docker Swarm collections, that the subject can access.
- **Roles**: Defines the type of access or operation a subject can perform on a resource set.
- **Grant**: Ties together the subject, resource set, and role to specify what a user (or team or org) can do with a specific set of resources.

## Getting Started with RBAC

Here's a quick guide to getting started:

1. **Create a User**:

- Navigate to `Access Control` on the left.
- Select `Users` and create a new user named "bob".

2. **Manage Organizations and Teams**:

- Go to `Orgs & Teams` to view organizations.
- Teams can be added within organizations.

3. **Docker Swarm Resource Sets**:

- Navigate to `Shared Resources > Collections`.
- Under the Swarm collection, click `View Children`.
- Create a new collection named "mycollection".

4. **Add Service to Collection**:

- Navigate to `Swarm > Services` and select the nginx service.
- Configure the service by clicking the gear icon.
- Assign the service to "mycollection".

5. **View Roles**:

- Go to `Access Control > Roles`.
- Switch between `Kubernetes` and `Swarm` to view respective roles.

6. **Create a Grant**:

- Navigate to `Access Control > Grants`.
- Click `Create Grant`.
- Assign the user "bob" with a `View Only` role for the nginx service in the "mycollection" resource set.

## LDAP Integration

UCP also offers integration with LDAP for user and team management:
- Under `admin > Admin Settings > Authentication & Authorization`, enable the LDAP toggle.
- Provide necessary LDAP server information.

## Relevant Documentation

- [Universal Control Plane overview](https://docs.mirantis.com/containers/v2.1/dockeree-products/ucp.html)
- [Enable LDAP and sync teams and users](https://docs.mirantis.com/msr/3.0/ops/manage-users/authentication-and-authorization/sync-ldap.html)

## Conclusion

With UCP's RBAC system, Docker cluster management becomes organized, clear, and secure. Ensure you use these tools to keep your resources accessible only to the right personnel.
