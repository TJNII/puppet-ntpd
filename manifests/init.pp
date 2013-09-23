class ntp (
  $ntp_servers = [ "0.pool.ntp.org",
   		   "1.pool.ntp.org",
                   "2.pool.ntp.org",
                   "3.pool.ntp.org", ]
  ) {
   case $operatingsystem {
      centos, redhat: { 
         $service_name = 'ntpd'
      }
      debian, ubuntu: { 
         $service_name = 'ntp'
      }
   }

   package { 'ntp':
      ensure => installed,
   }
      
   service { 'ntp':
      name      => $service_name,
      ensure    => running,
      enable    => true,
      subscribe => File['ntp.conf'],
   }
      
   file { 'ntp.conf':
      path    => '/etc/ntp.conf',
      ensure  => file,
      require => Package['ntp'],
      content  => template("ntp/ntp.conf.erb"),
   }
}
