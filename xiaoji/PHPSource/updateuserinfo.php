<?php 
include("MMysql.class.php");
	$response['success'] = false;
	$response['message'] = "参数错误";
	$response['code'] = -1;

	if ($_SERVER['REQUEST_METHOD']=="POST" && isset($_POST['signature']) && isset($_POST['nickname']) && isset($_POST['userid'])) {
		$nickname = $_POST['nickname'];
		$signature = $_POST['signature'];
		$userid = $_POST['userid'];
		if (strlen($nickname) > 0) {
			
			$success = replaceUserInfotWithUserID($userid,$nickname,$signature);

			if ($success) {
				$response['success'] = true;
				$response['message'] = "修改成功";
				$response['code']  = 1;
			}else{
				$response['message'] = "数据错误";
				$response['code']  = 1001;
			}

		}else{
			$response['message'] = "用户名不能为空";
			$response['code'] = 1000;
		}
	}

	echo json_encode($response);


function replaceUserInfotWithUserID($userid , $nickname,$signature){
	$configArray = array('host' => 'localhost', 'port'=>3306 , 'user'=>'root' , 'passwd'=>'root','dbname'=>'XJDB');
//创建数据库管理对象
	$mysql = new MMysql($configArray);

	$mysql->where(array("USERID"=>$userid));
	$num = $mysql->update("USERINFOTABLE",array('NICKNAME' => $nickname,'SIGNATURE' => $signature ));

	return $num > 0;
}
?>