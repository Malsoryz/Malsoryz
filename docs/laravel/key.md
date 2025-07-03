# Laravel Documents | Key

jika suatu saat sebuah projek laravel di clone, maka file `.env` tentu saja akan hilang dan tidak akan memiliki koneksi, kunci, atau nama aplikasi yang telah di konfigurasi di direktori atau perangkat sebelumnya jadi hal yang perlu dilakukan setelah menyalin `.env` dari `.env.example` adalah:

```bash
php artisan key:generate
```
ini untuk generate kunci aplikasi **Laravel**

```bash
php artisan reverb:install
```
jika sebelumnya, aplikasi **Laravel** menggunakan **Reverb** karena perintah ini juga akan generate kunci untuk **Reverb**