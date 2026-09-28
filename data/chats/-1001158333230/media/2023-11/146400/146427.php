<?php
// Android 10
// com.android.apksig.ApkVerifier
// services.jar
// com.android.server.pm.InstallPackageHelper
// com.android.server.pm.KeySetManagerService
// com.android.server.pm.PackageManagerServiceUtils
// framework.jar
// android.content.pm.ApplicationInfo
// android.content.pm.PackageParser
// android.content.pm.PackageParser$SigningDetails
// android.content.pm.SigningDetails
// android.content.res.AssetManager
// android.util.apk.ApkSignatureSchemeV2Verifier
// android.util.apk.ApkSignatureSchemeV3Verifier
// android.util.apk.ApkSignatureVerifier
// android.util.apk.ApkSigningBlockUtils
// android.util.jar.StrictJarVerifier


echo "* PHP Smali Patcher by NekoYuzu (MlgmXyysd)" . PHP_EOL;
echo "	* Contains: App Signature & Flag Secure Crack" . PHP_EOL;


error_reporting(0);

// Insert Before Method Patches
$methods = array(
	// Core Patch
	array(
		"com.android.server.pm.KeySetManagerService",
		"shouldCheckUpgradeKeySetLocked",
		"",
		"invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
move-result-object v0
invoke-virtual {v0}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;
move-result-object v0
invoke-static {v0}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;
move-result-object v0
const-string v1, \"preparePackageLI\"
invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
move-result v0
if-eqz v0, :cond_ff
const/4 v0, 0x1
return v0
:cond_ff"
	),
	array(
		"com.android.server.pm.KeySetManagerService",
		"checkUpgradeKeySetLocked",
		"",
		"invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;
move-result-object v0
invoke-virtual {v0}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;
move-result-object v0
invoke-static {v0}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;
move-result-object v0
const-string v1, \"preparePackageLI\"
invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
move-result v0
if-eqz v0, :cond_ff
const/4 v0, 0x1
return v0
:cond_ff"
	),
	array(
		"android.util.jar.StrictJarVerifier",
		"verifyBytes",
		"",
		"new-instance v0, Lsun/security/pkcs/PKCS7;
invoke-direct {v0, p0}, Lsun/security/pkcs/PKCS7;-><init>([B)V
invoke-virtual {v0}, Lsun/security/pkcs/PKCS7;->getSignerInfos()[Lsun/security/pkcs/SignerInfo;
move-result-object v1
const/4 v2, 0x0
aget-object v1, v1, v2
invoke-virtual {v1, v0}, Lsun/security/pkcs/SignerInfo;->getCertificateChain(Lsun/security/pkcs/PKCS7;)Ljava/util/ArrayList;
move-result-object v1
new-array v2, v2, [Ljava/security/cert/X509Certificate;
invoke-virtual {v1, v2}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
move-result-object v1
check-cast v1, [Ljava/security/cert/Certificate;
return-object v1"
	),
	array(
		"android.util.jar.StrictJarVerifier",
		"verifyMessageDigest",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"android.util.jar.StrictJarVerifier",
		"verify",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"com.android.server.pm.PackageManagerServiceUtils",
		"verifySignatures",
		"",
		"const/4 v0, 0x0
return v0"
	),
	array(
		"android.content.res.AssetManager",
		"containsAllocatedTable",
		"",
		"const/4 v0, 0x0
return v0"
	),
	array(
		"android.util.apk.ApkSignatureVerifier",
		"getMinimumSignatureSchemeVersionForTargetSdk",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"com.android.apksig.ApkVerifier",
		"getMinimumSignatureSchemeVersionForTargetSdk",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"android.content.pm.ApplicationInfo",
		"isPackageWhitelistedForHiddenApis",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"com.android.server.pm.PackageManagerServiceUtils",
		"checkDowngrade",
		"Lcom/android/server/pm/parsing/pkg/AndroidPackage;Landroid/content/pm/PackageInfoLite;",
		"return-void"
	),
	array(
		"com.android.server.pm.PackageManagerServiceUtils",
		"checkDowngrade",
		"Landroid/content/pm/PackageInfoLite;Landroid/content/pm/PackageInfoLite;",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"android.content.pm.SigningDetails",
		"checkCapability",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"android.content.pm.SigningDetails",
		"checkCapabilityRecover",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"android.content.pm.PackageParser\$SigningDetails",
		"checkCapability",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"android.content.pm.PackageParser\$SigningDetails",
		"checkCapabilityRecover",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"com.android.server.pm.InstallPackageHelper",
		"doesSignatureMatchForPermissions",
		"",
		"const/4 v0, 0x1
return v0"
	),
	array(
		"android.util.jar.StrictJarVerifier",
		"<init>",
		"",
		"const/4 p4, 0x0"
	),
	array(
		"android.content.pm.PackageParser",
		"getApkSigningVersion",
		"",
		"const/4 v0, 0x1
return v0"
	),
	// Flag Secure
	array(
		"com.android.server.wm.WindowState",
		"isSecureLocked",
		"",
		"const/4 v0, 0x0
return v0"
	)
);

foreach ($methods as $val) {
	$path = str_replace(".", DIRECTORY_SEPARATOR, $val[0]) . ".smali";
	$method = $val[1];
	$param = $val[2];
	$add = $val[3];
	$result = "";
	$l = 0;
	$file = fopen($path, "r");
	if ($file) {
		echo "* We are in " . $val[0] . "." . $method . PHP_EOL;
		$is_in_target_method = false;
		while (($line = fgets($file)) !== false) {
			$result .= $line;
			if (str_starts_with($line, ".method") && str_contains($line, $method . "(" . $param) && !$is_in_target_method) {
				$is_in_target_method = true;
			}
			if ($is_in_target_method && !str_starts_with(ltrim($line), ".") && ltrim($line) == "") {
				echo "    - Patch " . $val[0] . "." . $method . ": Line " . $l . PHP_EOL;
				$result .= $add . PHP_EOL;
				$is_in_target_method = false;
			}
			$l++;
		}
		fclose($file);
		file_put_contents($path, $result);
		echo "  - Done " . $val[0] . "." . $method . PHP_EOL;
	} else {
		echo "! Failed to patch " . $val[0] . "." . $method . PHP_EOL;
	}
}

// Multiple Methods Patches
$methods_mp = array(
	// Core Patch
	array(
		"android.util.apk.ApkSignatureSchemeV3Verifier",
		"verifySigner",
		"",
		"invoke-static {",
		"}, Ljava/security/MessageDigest;->isEqual([B[B)Z",
		"const/4",
		"0x1"
	),
	array(
		"android.util.apk.ApkSignatureSchemeV2Verifier",
		"verifySigner",
		"",
		"invoke-static {",
		"}, Ljava/security/MessageDigest;->isEqual([B[B)Z",
		"const/4",
		"0x1"
	),
	array(
		"android.util.apk.ApkSigningBlockUtils",
		"verifyIntegrityFor1MbChunkBasedAlgorithm",
		"",
		"invoke-static {",
		"}, Ljava/security/MessageDigest;->isEqual([B[B)Z",
		"const/4",
		"0x1"
	)
);

foreach ($methods_mp as $val) {
	$path = str_replace(".", DIRECTORY_SEPARATOR, $val[0]) . ".smali";
	$method = $val[1];
	$param = $val[2];
	$starts = $val[3];
	$mname = $val[4];
	$mresult_1 = $val[5];
	$mresult_2 = $val[6];
	$result = "";
	$file = fopen($path, "r");
	$l = 0;
	if ($file) {
		echo "* We are in " . $val[0] . "." . $method . PHP_EOL;
		$is_in_target_method = false;
		$is_after_isEqual = false;
		while (($line = fgets($file)) !== false) {
			$result .= $line;
			if (str_starts_with($line, ".method") && str_contains($line, $method . "(" . $param) && !$is_in_target_method) {
				$is_in_target_method = true;
			}
			if (str_starts_with(ltrim($line), $starts) && str_contains($line, $mname) && $is_in_target_method) {
				$is_after_isEqual = true;
			}
			if ($is_in_target_method && $is_after_isEqual && str_starts_with(ltrim($line), "move-result v")) {
				echo "    - Patch " . $val[0] . "." . $method . ": Line " . $l . PHP_EOL;
				$reg_name = str_replace("move-result ", "", ltrim($line));
				$result .= $mresult_1 . " " . $reg_name . ", " . $mresult_2 . PHP_EOL;
				$is_after_isEqual = false;
			}
			if (str_starts_with($line, ".end method") && $is_in_target_method) {
				$is_in_target_method = false;
			}
			$l++;
		}
		fclose($file);
		file_put_contents($path, $result);
		echo "  - Done " . $val[0] . "." . $method . PHP_EOL;
	} else {
		echo "! Failed to patch " . $val[0] . "." . $method . PHP_EOL;
	}
}

// Replace Android Platform Test Keys if apk don't contain cert
$path = str_replace(".", DIRECTORY_SEPARATOR, "android.util.apk.ApkSignatureVerifier") . ".smali";
$file = fopen($path, "r");
$add = "new-instance v0, Landroid/util/apk/ApkSignatureVerifier\$SigningDetailsWithDigests;
new-instance v1, Landroid/content/pm/SigningDetails;
const/4 v9, 0x1
new-array v8, v9, [Landroid/content/pm/Signature;
new-instance v6, Landroid/content/pm/Signature;
const-string v7, \"308203c6308202aea003020102021426d148b7c65944abcf3a683b4c3dd3b139c4ec85300d06092a864886f70d01010b05003074310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e205669657731143012060355040a130b476f6f676c6520496e632e3110300e060355040b1307416e64726f69643110300e06035504031307416e64726f6964301e170d3139303130323138353233385a170d3439303130323138353233385a3074310b3009060355040613025553311330110603550408130a43616c69666f726e6961311630140603550407130d4d6f756e7461696e205669657731143012060355040a130b476f6f676c6520496e632e3110300e060355040b1307416e64726f69643110300e06035504031307416e64726f696430820122300d06092a864886f70d01010105000382010f003082010a028201010087fcde48d9beaeba37b733a397ae586fb42b6c3f4ce758dc3ef1327754a049b58f738664ece587994f1c6362f98c9be5fe82c72177260c390781f74a10a8a6f05a6b5ca0c7c5826e15526d8d7f0e74f2170064896b0cf32634a388e1a975ed6bab10744d9b371cba85069834bf098f1de0205cdee8e715759d302a64d248067a15b9beea11b61305e367ac71b1a898bf2eec7342109c9c5813a579d8a1b3e6a3fe290ea82e27fdba748a663f73cca5807cff1e4ad6f3ccca7c02945926a47279d1159599d4ecf01c9d0b62e385c6320a7a1e4ddc9833f237e814b34024b9ad108a5b00786ea15593a50ca7987cbbdc203c096eed5ff4bf8a63d27d33ecc963990203010001a350304e300c0603551d13040530030101ff301d0603551d0e04160414a361efb002034d596c3a60ad7b0332012a16aee3301f0603551d23041830168014a361efb002034d596c3a60ad7b0332012a16aee3300d06092a864886f70d01010b0500038201010022ccb684a7a8706f3ee7c81d6750fd662bf39f84805862040b625ddf378eeefae5a4f1f283deea61a3c7f8e7963fd745415153a531912b82b596e7409287ba26fb80cedba18f22ae3d987466e1fdd88e440402b2ea2819db5392cadee501350e81b8791675ea1a2ed7ef7696dff273f13fb742bb9625fa12ce9c2cb0b7b3d94b21792f1252b1d9e4f7012cb341b62ff556e6864b40927e942065d8f0f51273fcda979b8832dd5562c79acf719de6be5aee2a85f89265b071bf38339e2d31041bc501d5e0c034ab1cd9c64353b10ee70b49274093d13f733eb9d3543140814c72f8e003f301c7a00b1872cc008ad55e26df2e8f07441002c4bcb7dc746745f0db\"
invoke-direct {v6, v7}, Landroid/content/pm/Signature;-><init>(Ljava/lang/String;)V
const/4 v7, 0x0
aput-object ";
$add2 = ", v8, v7
invoke-direct {v1, v8, v9}, Landroid/content/pm/SigningDetails;-><init>([Landroid/content/pm/Signature;I)V
const/4 v9, 0x0
invoke-direct {v0, v1, v9}, Landroid/util/apk/ApkSignatureVerifier\$SigningDetailsWithDigests;-><init>(Landroid/content/pm/SigningDetails;Ljava/lang/Object;)V
move-object/from16 v1, p0
invoke-virtual {v1, v0}, Landroid/content/pm/parsing/result/ParseInput;->success(Ljava/lang/Object;)Landroid/content/pm/parsing/result/ParseResult;
move-result-object v0
return-object v0";
if ($file) {
	echo "* We are in android.util.apk.ApkSignatureVerifier.verifyV1Signature" . PHP_EOL;
	$is_in_target_method = false;
	$is_done = false;
	$lastSigs = "v6";
	$l = 0;
	$result = "";
	while (($line = fgets($file)) !== false) {
		if (str_starts_with($line, ".method") && str_contains($line, "verifyV1Signature(") && !$is_done && !$is_in_target_method) {
			$is_in_target_method = true;
		}
		if (str_starts_with(ltrim($line), ".local ") && str_contains($line, ", \"lastSigs\":[Landroid/content/pm/Signature;") && $is_in_target_method) {
			$lastSigs = explode(",", str_replace(".local ", "", ltrim($line)))[0];
		}
		if (str_starts_with(ltrim($line), ".end local " . $lastSigs) && $is_in_target_method) {
			$lastSigs = "v6";
		}
		if (str_starts_with(ltrim($line), "invoke-interface {") && str_contains($line, "}, Landroid/content/pm/parsing/result/ParseInput;->error(") && $is_in_target_method) {
			echo "    - Patch android.util.apk.ApkSignatureVerifier.verifyV1Signature: Line " . $l . PHP_EOL;
			$result .= $add . $lastSigs . $add2 . PHP_EOL;
		}
		if (str_starts_with($line, ".end method") && $is_in_target_method) {
			$is_in_target_method = false;
			$is_done = true;
		}
		$result .= $line;
		$l++;
	}
	fclose($file);
	file_put_contents($path, $result);
	echo "  - Done android.util.apk.ApkSignatureVerifier.verifyV1Signature" . PHP_EOL;
} else {
	echo "! Failed to patch android.util.apk.ApkSignatureVerifier.verifyV1Signature" . PHP_EOL;
}