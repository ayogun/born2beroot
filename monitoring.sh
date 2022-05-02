arc=$(uname -a)																								                                  	--> Mevcut işletim sisteminin mimarisi ve kernel versiyonunu gösterir.
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)											        		--> Fiziksel işlemci sayısını verir.
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)														              			--> Sanal işlemci sayısını verir.
fram=$(free -m | awk '$1 == "Mem:" {print $2}')																                	--> Sunucunun erişilebilir RAM miktarını verir.
uram=$(free -m | awk '$1 == "Mem:" {print $3}')																            	    --> Kullanılan RAM miktarını verir.
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')									        				--> printf("%.2f") virgülden sonra alınacak 2 değeri yollar $3/$2*100 ise yüzde olarak kullanımı verir
fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')							--> Sunucunun erişilebilir depolama miktarını verir.
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')							--> Sunucunun kullanılan depolama alanını verir.
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')	--> "kullanılan depolama alanı / erişilebilir alan * 100" bize yüzde kullanımını verir.
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')							--> Yüzde olarak işlemci kullanım oranını verir.
lb=$(who -b | awk '$1 == "sistem" {print $3 " " $4}')															              --> Son yeniden başlatma tarihi ve saatini verir.
lvmt=$(lsblk | grep "lvm" | wc -l)																			                  	--> LVM ile yapılandırılmış disklerin bilgisini verir.
lvmu=$(if [ $lvmt -eq 0 ]; then echo hayır; else echo evet; fi)												      		--> Sistemde LVM'nin aktif olup olmadığı bilgisini verir. NOT: Diğer öğelerin sorunsuz çalışması için net-tools paketini yüklemeniz gerekli.
ctcp=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {print $3}')									      			--> Mevcut aktif bağlantı sayısını verir.
ulog=$(users | wc -w)																						                    	--> Sunucuyu kullanan kullanıcı sayısını verir.
ip=$(hostname -I)																								                     --> Sunucu IP Adresini verir.
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')														--> Sunucu MAC Adresini verir.
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)												    			--> Sudo ile çalışıtırlmış komut sayısını verir. (Eğer sudoya giriş yapılmış ise diğer kullanıcıların sudo kullanım sayısıyla birlikte yazar öyle değilse içinde bulunulan kullanıcının kullandığı sudo command kadar bilgi verir.)


wall "	#Mimari ve Kernel Versiyonu: $arc
	      #Fiziksel İşlemci Sayısı: $pcpu
	      #Sanal İşlemci Sayısı: $vcpu
	      #RAM Miktar ve Kullanımı: $uram/${fram}MB ($pram%)
      	#Disk Miktarı ve Kullanımı: $udisk/${fdisk}Gb ($pdisk%)
	      #CPU Kullanım Oranı: $cpul
	      #Son Yeniden Başlama Tarihi: $lb
	      #LVM Kullanım Durumu: $lvmu
      	#Aktif Bağlantı Sayısı: $ctcp ESTABLISHED
      	#Sunucuyu Kullanan K. Sayısı: $ulog
	      #IP ve MAC Adresi: IP $ip ($mac)
	      #Kullanılmış Sudo Sayısı: $cmds cmd" # Diğer termianallerde gözükmesi için bunu ekliyoruz.
