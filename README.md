# **Inception**

## Description
<table>
  <tr>
    <td>
      <img src="https://github.com/ayogun/42-project-badges/blob/main/badges/inceptionn.png" alt="Inception 42 project badge" width="400"/>
    </td>
    <td>
      Inception is a 42 school sysadmin project where you need to build from scratch a tiny infrastructure with different services to host a website.
      Coding in shell and using <a href="https://www.docker.com/">Docker</a> system.
    </td>
  </tr>
</table>

## :memo: Status
<p align="center">
  <img src="https://github.com/sponthus/assets/blob/main/42school/scores/100_outstanding.png" alt="100 grade - outstanding"/>
  <br><strong>Validated 2025-03-28</strong>
  <br>Outstanding :star:
</p>

## :orange_book: Features
+ Using `docker-compose` and recreating a Dockerfile for every service from the oldstable Alpine or Debian version (at the time, <a href="https://www.debian.org/releases/bookworm/">Debian Bookworm</a>)
+ <a href="https://nginx.org/">Nginx</a> container, with TLSv1.2 or TLSv1.3
+ <a href="https://wordpress.com/">Wordpress</a> container, with php-fpm configured and running (files on a volume)
+ <a href="https://mariadb.org/">MariaDB</a> container, with a WordPress database (on a 2nd volume)
+ Linked by a `docker network`

## :cyclone: Clone
Clone the repository and enter it :
```shell
git clone https://github.com/sponthus/Inception
cd Inception
```

## 	:runner: Run
From the project directory, use :
```shell
make
```
If you run this for the first time, a script will run to ask informations and login.
A few rules apply :
* The wordpress admin username must not contain "admin" or something similar - ex: "adm-123" ...
* Usernames must not be empty
  
Passwords will be automatically generated and stored in `secrets/` directory.  
Emails will be automatically assumed as `username@42lyon.fr`, as this is a school project. 👼  
Access the website at `localhost`. You will need to accept the certificate because it is auto-signed.  
You can access Wordpress administration using `/wp-admin` and log-in.  

:hugs: Enjoy !
---
Made by sponthus
