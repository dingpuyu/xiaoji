
<?php
include("MMysql.class.php");

$response['success'] = true;
$response['message'] = "注册成功";
$response['code'] = 1;

if ($_SERVER['REQUEST_METHOD']=="POST" && isset($_POST['nickname']) && isset($_POST['account']) && isset($_POST['password1']) && isset($_POST['password2'])) {

$nickname = addslashes(sprintf("%s",$_POST['nickname']));
$account = addslashes(sprintf("%s",$_POST['account']));
$password1 = $_POST['password1'];
$password2 = $_POST['password2'];

//数据库连接配置文件
$configArray = array('host' => 'localhost', 'port'=>3306 , 'user'=>'root' , 'passwd'=>'root','dbname'=>'XJDB');
//创建数据库管理对象
$mysql = new MMysql($configArray);

$sql = "select ACCOUNT from USERINFOTABLE where ACCOUNT = '".test_input($account)."';";

$result = $mysql->doSql($sql);

	if (count($result) > 0) {//如果查询结果不为空，说明账号已存在
		$response['success'] = false;
		$response['message'] = "账号已存在";
		$response['code'] = 1004;
	}else{
			if (strlen(test_input($nickname)) <= 0) {
				$response['success'] = false;
				$response['message'] = "请输入正确的用户名";
				$response['code'] = 1003;
			}else{
				$account = test_input($account);
				$pattern = "/^([0-9A-Za-z\\-_\\.]+)@([0-9a-z]+\\.[a-z]{2,3}(\\.[a-z]{2})?)$/i";
				if (!preg_match($pattern,$account)) {
					$response['success'] = false;
					$response['message'] = "数据错误";
					$response['code'] = 1002;						
				}else{
					if (($password1 != $password2) || ($password1 == "") || strlen($password1) <= 0 || is_null($password1) || is_null($password2))  {
						$response['success'] = false;
						$response['message'] = "密码校验错误";
						$response['code'] = 1001;							
					}else{
						$response['success'] = true;
						$response['message'] = "注册成功";
						$response['code'] = 1;
						$columnName = "USERINFOTABLE";
					    $success = $mysql->insert($columnName,array('NICKNAME' => $nickname,'ACCOUNT' => $account,'PASSWORD' => $password1));
					    if ($success <= 0) {
					    	$response['success'] = false;
							$response['message'] = "写入失败";
							$response['code'] = 1000;
					    }


					}
				}	
			}
	
	}
}else{
	$response['success'] = false;
	$response['message'] = "请检查输入信息是否完整";
	$response['code'] = -1;	
}

echo json_encode($response);
?>


<?php

function test_input($data){
	$data = trim($data);
	$data = stripslashes($data);
	$data = htmlspecialchars($data);
	return $data;
}

?>

<?php 
$nameErr = $emailErr = $genderErr = $commentErr = $websiteErr = "";

$name = $email = $gender = $comment = $website = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	if (empty($_POST["name"])) {
		$nameErr = "Name is required";
	} else {
		$name = test_input($_POST["name"]);
		if(!preg_match("/^[a-zA-z ]*$/",$name)){
			$nameErr = "只允许字母和空格!";
		}
	}
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	if (empty($_POST["email"])) {
		$emailErr = "email is required";
	} else {
		$email = test_input($_POST["email"]);
		$pattern = "/^([0-9A-Za-z\\-_\\.]+)@([0-9a-z]+\\.[a-z]{2,3}(\\.[a-z]{2})?)$/i";
		if (!preg_match($pattern,$email)) {
			$emailErr = "您输入的验证码有误！";
		}


	}
}

?>