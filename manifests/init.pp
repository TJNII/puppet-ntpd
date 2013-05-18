class ntp {
   case $operatingsystem {
      centos, redhat: { 
         $service_name = 'ntpd'
      }
      debian, ubuntu: { 
         $service_name = 'ntp'
      }
   }

   $ntp_servers = [ "ntp1.tjnii.com",
   		    "ntp2.tjnii.com", ]

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
