<?php 
	include("MMysql.class.php");

	$response['success'] = false;
	$response['message'] = "无结果";
	$response['data'] = [];
	$response['code'] = -1;

	if (($_SERVER['REQUEST_METHOD'] == 'POST' ) && isset($_POST['userid'])) {
		$configArray = array('host' => 'localhost', 'port'=>3306 , 'user'=>'root' , 'passwd'=>'root','dbname'=>'XJDB');
		$userid = addslashes(sprintf("%s",$_POST['userid']));
//创建数据库管理对象
		$mysql = new MMysql($configArray);

		$sql =  "select USERID,NICKNAME,ACCOUNT,PASSWORD,BIRTHDAY,AVATAR,SIGNATURE FROM USERINFOTABLE where USERID = '".$userid."';";

		$result = $mysql->doSql($sql);
		if (!is_null($result)) {
			$result = $result[0];
			$response['data'] = array('nickname' => $result['NICKNAME'],'signature' => $result['SIGNATURE'] , 'account' => $result['ACCOUNT'] ,'password' => $result['PASSWORD'],'avatar' => $result['AVATAR'],'birthday' => $result['BIRTHDAY'] );
			$response['success'] = true;
			$response['message'] = '查询成功';
			$response['code'] = 1;
		}
	}

	echo json_encode($response);
?>