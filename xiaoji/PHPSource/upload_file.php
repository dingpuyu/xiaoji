<?php
include("MMysql.class.php");

	$response['success'] = false;
	$response['message'] = "上传失败";
	$response['code'] = -1;
	if(!empty($GLOBALS['HTTP_RAW_POST_DATA']) && strlen($GLOBALS['HTTP_RAW_POST_DATA'])>0) {
		$date = $GLOBALS['HTTP_RAW_POST_DATA'];
		$fid = time().".".getfileType();
        $absoluteName  = dirname(__FILE__)."/upload/".$fid;
        $handleWrite = fopen($absoluteName,'a');
         
        fwrite($handleWrite,$GLOBALS['HTTP_RAW_POST_DATA']);
        
        fclose($handleWrite);
		$success = replaceAvatarWithAccount(getAccountHeader(),"http://".$_SERVER['SERVER_NAME']."/upload/".$fid);
		if ($success == true) {
			 $response['success'] = true;
			 $response['message'] = "上传成功";
			 $response['code'] = 1;
		}
		echo json_encode($response);
	}


function getAccountHeader()
    {
    	$header = "";

    	$dict = getallheaders();
       return $dict['HTTP_ACCOUNT'];
    }

function getfileType(){
        $str_info  = @unpack("C2chars",  $GLOBALS['HTTP_RAW_POST_DATA']);
        $type_code = intval($str_info['chars1'].$str_info['chars2']);
        $file_type = '';
        switch ($type_code) {
            case 7790:
                $file_type = 'exe';
                break;
            case 7784:
                $file_type = 'midi';
                break;
            case 8075:
                $file_type = 'zip';
                break;
            case 8297:
                $file_type = 'rar';
                break;
            case 255216:
                $file_type = 'jpg';
                break;
            case 7173:
                $file_type = 'gif';
                break;
            case 6677:
                $file_type = 'bmp';
                break;
            case 13780:
                $file_type = 'png';
                break;
            default:
                $file_type = 'unknown';
                break;
        }
        return $file_type;
}

function replaceAvatarWithAccount($account , $url){
	$configArray = array('host' => 'localhost', 'port'=>3306 , 'user'=>'root' , 'passwd'=>'root','dbname'=>'XJDB');
//创建数据库管理对象
	$mysql = new MMysql($configArray);

	$mysql->where(array("ACCOUNT"=>"'".$account."'"));
	$num = $mysql->update("USERINFOTABLE",array('AVATAR' => $url ));

	return $num > 0;
}




?>