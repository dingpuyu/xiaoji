<?php 
include("MMysql.class.php");

$response["success"] = true;
$response["message"] = "登陆成功";
$response["code"] = 1;


if ($_SERVER['REQUEST_METHOD']=="POST" && isset($_POST['password']) && isset($_POST['account'])) {
//数据库连接配置文件
$configArray = array('host' => 'localhost', 'port'=>3306 , 'user'=>'root' , 'passwd'=>'root','dbname'=>'XJDB');
//创建数据库管理对象
$mysql = new MMysql($configArray);

$account = $_POST['account'];
$account = addslashes(sprintf("%s",$account));//过滤，防止sql注入
$password = $_POST['password'];

if ((strlen($account) <= 0) || (strlen($password) <=0)) {
	$response["success"] = false;
	$response["message"] = "账户密码不能为空";
	$response["code"] = 1001;	
	echo json_encode($response);
	return;
}

$accountSql =  "select ACCOUNT,PASSWORD  from USERINFOTABLE where ACCOUNT='".$account."';";
	$result = $mysql->doSql($accountSql);
	if (count($result) > 0) {

		$result = $result[0];
		$localpassword = $result['PASSWORD'];

		if ($localpassword == $password) {
			$response['success'] = true;
		    $response['message'] = "登陆成功";
		    $response['code'] = 1000;//登陆成功
		}else{
			$response['success'] = false;
		    $response['message'] = "密码错误";
		    $response['code'] = 1004;//登陆成功
		}

	}else{
		$response['success'] = false;
		$response['message'] = "账户不存在";
		$response['code']    = 1001; 
	}
	
}else{
	$response["success"] = false;
	$response["message"] = "账户密码";
    $response["code"] = -1;
}


echo json_encode($response);

?>