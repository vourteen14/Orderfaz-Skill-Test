## How to use

### Install mcli

````curl -O https://dl.min.io/client/mc/release/linux-amd64/mc````
````chmod +x mc````
````sudo mv mc /usr/local/bin/mcli````

### Buat alias MiniO

````mcli alias set postgresql-backup https://<MINIO-API> <ACCESS-KEY> <SECRET-KEY>````

### How to setup backup

Jalankan perintah dibawah ini:

````sudo crontab -e````

Tambahkan script berikut pada bagian paling bawah:

````0 2 * * * /root/backup-script-minio.sh >> /var/log/backup.log 2>&1````

Notes:
* backup dibuat schedule pada jam 02:00 WIB pagi, mengikuti waktu server yang sudah menjadi WIB
* script backup disimpan di /root/backup-script-minio.sh
* mcli harus sudah terinstall & sudah setup minio alias untuk target bucket database backup

### How to restore
Untuk melakukan restore bisa langsung menjalankan perintah dibawah:

````sudo ./restore-script-minio.sh````

Perintah diatas akan melakukan listing terhadap 7 file backup terakhir pada bucket, script tersebut akan mengintruksikan untuk memilih nama backup yang akan di restore, setelah masukan nama file backup maka proses restore akan berjalan

Notes:
* mcli harus sudah terinstall & sudah setup minio alias untuk target bucket database backup
