<?php

if( $argc < 2 )
    throw new \Exception(" must have an argument");

$mode = (isset($argv[1])) ? $argv[1] : "local"; 
$subdomain = (isset($argv[2])) ? $argv[2] : "api"; 
$domain = (isset($argv[3])) ? $argv[3] : "stringy.io";

$defaultFastCgiPass = "unix:/run/php/php5.6-fpm.sock";

mkDocsConfFile($mode, $subdomain, $domain, $defaultFastCgiPass);

function mkDocsConfFile($mode, $subdomain, $domain, $fastCgiPass)
{
//    print "Making nginx conf files for $mode.$subdomain.$domain \n";

    $templateFileName = realpath(__DIR__)."/templates/stringy.$subdomain.template.conf";

    $outputFileName = realpath(__DIR__."/../sites-available")."/stringy.$subdomain.$mode.autogen.conf";

    // print "TEMPLATE: ".$templateFileName . "\n"; 
    // print "OUPTUTFILE: ".$outputFileName . "\n"; 

    $templateString = file_get_contents($templateFileName);

    $config = doConfig($mode, $subdomain, $domain);
    
    $s0 = str_replace('${FASTCGI_PASS}', $fastCgiPass, $templateString);

    $s1 = str_replace('${SERVER_NAMES}',$config->serverNames, $s0);
    
    $s2 = str_replace('${ACCESS_LOG}',$config->accessLog, $s1);
    $s3 = str_replace('${ERROR_LOG}',$config->errorLog, $s2);
	
	if( $subdomain === "api" ){
		$sTemp = str_replace('${MODE}', $mode, $s3);
		$s3 = $sTemp;
	}
	
    if( $subdomain === "frontend")
        $s4 = $s3;
    else
        $s4 = str_replace('${DOCUMENT_ROOT}',$config->docRoot, $s3);

    // print $templateString;
    // print "\n====================================\n";
    print $s4;
}

function doConfig($mode, $subdomain, $domain)
{
    $serverNames = "www.$mode.$subdomain.$domain $mode.$subdomain.$domain";
    if( $subdomain === 'frontend' ){
        $serverNames = "www.$mode.$domain $mode.$domain";
        if( $mode === 'live' )
            $serverNames = "www.$domain $domain";
    }
    
    if( $mode === "local"){
        $logPrefix = "/usr/local/etc/nginx/logs";
        $docRoot = "/Users/rob/StringyProject/Stringy/$subdomain/public";
    }else{
        $logPrefix = "/etc/nginx/logs";
        $logPrefix = "/var/log/nginx";
        $docRoot = "/home/robert/www/$mode.$domain/$subdomain/public";
    }    
    
    $errorLog = $logPrefix."/$mode.$subdomain.$domain.error.log";
    $accessLog = $logPrefix."/$mode.$subdomain.$domain.access.log";
         
        
    $result = new stdClass();
    $result->serverNames = $serverNames;
    $result->accessLog = $accessLog;
    $result->errorLog = $errorLog;
    $result->docRoot = $docRoot;
    return $result;
}

?>