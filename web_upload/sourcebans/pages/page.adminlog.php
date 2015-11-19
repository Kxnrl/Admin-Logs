<?php
/**
 * =============================================================================
 * Adminlogs page
 *
 * @author SteamFriends Development Team and maoling
 * @version 1.0.0
 * @copyright SourceBans (C)2007 SteamFriends.com.  All rights reserved.
 * @package SourceBans
 * @link http://www.sourcebans.net
 * 
 * @version $Id: page.adminlog.php 292 2015-11-19 20:10:12 Tiara.xQy//Maoling $
 * =============================================================================
 */
global $theme;
if(!defined("IN_SB")){echo "You should not be here. Only follow links!";die();}

define('BANS_PER_PAGE', SB_BANS_PER_PAGE);
$bd_user = "urdbuser";
$bd_password = "password";
$bd = "sourcebans";
$host = "urhost";
$bd_table = "admin_log";  // ur table
$conexao = mysqli_connect($host,$bd_user,$bd_password,$bd);
$page = 1;
if (isset($_GET['page']) && $_GET['page'] > 0)
{
	$page = intval($_GET['page']);
}
$BansStart = BANS_PER_PAGE * ($page - 1);
$query1 = "SELECT * FROM `$bd_table` ORDER BY time DESC LIMIT $BansStart, 30";
mysqli_set_charset($conexao,"latin1");  // set latin1
$resultado1 = mysqli_query($conexao,$query1);
$BansEnd = $BansStart + mysqli_affected_rows($conexao);
$query2 = "SELECT COUNT(*) FROM `$bd_table`";
$resultado2 = mysqli_query($conexao,$query2);
$BanCount = mysqli_fetch_row($resultado2)[0];
$bans = array();
while ($row = mysqli_fetch_array($resultado1))
{
	$data = array();
	$data['ban_date'] = $row['time'];
	$data['player'] = $row['hostname'];
	$data['admin'] = htmlentities($row['message']);
	array_push($bans,$data);
}

//=================[ Start Layout ]==================================
$ban_nav = 'displaying&nbsp;'.$BansStart.'&nbsp;-&nbsp;'.$BansEnd.'&nbsp;of&nbsp;'.$BanCount.'&nbsp;results';

if ($page > 1)
{
	$ban_nav .= ' | <b>'.CreateLinkR('<img border="0" alt="prev" src="images/left.gif" style="vertical-align:middle;" /> prev',"index.php?p=adminlog&page=".($page-1)).'</b>';
}
if ($BanCount > $BansEnd)
{
	$ban_nav .= ' | <b>'.CreateLinkR('next <img border="0" alt="next" src="images/right.gif" style="vertical-align:middle;" />',"index.php?p=adminlog&page=".($page+1)).'</b>';
}
$pages = ceil($BanCount/BANS_PER_PAGE);
if($pages > 1) {
	$ban_nav .= '&nbsp;<select onchange="changePage(this,\'BA\',\''.'\',\''.'\');">';
	for($i=1;$i<=$pages;$i++)
	{
		if(isset($_GET["page"]) && $i == $page) {
			$ban_nav .= '<option value="' . $i . '" selected="selected">' . $i . '</option>';
			continue;
		}
		$ban_nav .= '<option value="' . $i . '">' . $i . '</option>';
	}
	$ban_nav .= '</select>';
}
//----------------------------------------

unset($_SESSION['CountryFetchHndl']);

$theme->assign('ban_list', $bans);
$theme->assign('ban_nav', $ban_nav);
$theme->display('page_adminlog.tpl');
?>
