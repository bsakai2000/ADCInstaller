<?php
require __DIR__ . '/vendor/autoload.php';
use ParagonIE\ConstantTime\Base32;
$secret = random_bytes(32);
echo trim(Base32::encodeUpper($secret), '=');
$base16 = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
echo "\nuint8_t hmacKey[] = {";
while(strlen($secret) != 0)
{
	echo '0x';
	$index = ord($secret);
	echo $base16[$index / 16];
	echo $base16[$index % 16];
	$secret = substr($secret, 1);
	echo ', ';
}
echo "}\n";
?>
