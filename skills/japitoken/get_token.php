<?php
/**
 * Joomla API Token Retriever
 * This script retrieves a valid Joomla API token for local development sites
 */

// Suppress all output except our JSON
error_reporting(0);
ini_set('display_errors', '0');

try
{
	// Require Joomla configuration
	$curDir = __DIR__;

	if (!file_exists($curDir . '/configuration.php'))
	{
		$curDir = getcwd();
	}

	if (!file_exists($curDir . '/configuration.php'))
	{
		throw new Exception('configuration.php not found');
	}

	require_once $curDir . '/configuration.php';

	// Create JConfig object
	$config   = new JConfig();
	$secret   = $config->secret;
	$dbPrefix = $config->dbprefix;

	// Connect to database
	$dsn = "mysql:host={$config->host};dbname={$config->db};charset=utf8mb4";
	$pdo = new PDO(
		$dsn, $config->user, $config->password, [
		PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
		PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
	]
	);

	// Find Super Users (group_id=8)
	$stmt = $pdo->prepare("SELECT DISTINCT user_id FROM {$dbPrefix}user_usergroup_map WHERE group_id = 8");
	$stmt->execute();
	$superUserIds = array_column($stmt->fetchAll(), 'user_id');

	if (empty($superUserIds))
	{
		throw new Exception('No Super Users found');
	}

	// Filter active users (block=0, activation NULL or empty)
	$placeholders = implode(',', array_fill(0, count($superUserIds), '?'));
	$stmt         = $pdo->prepare(
		"
        SELECT id FROM {$dbPrefix}users
        WHERE id IN ($placeholders)
        AND block = 0
        AND (activation IS NULL OR activation = '')
    "
	);
	$stmt->execute($superUserIds);
	$activeUserIds = array_column($stmt->fetchAll(), 'id');

	if (empty($activeUserIds))
	{
		throw new Exception('No active Super Users found');
	}

	// Find users with joomlatoken.enabled = 1
	$placeholders = implode(',', array_fill(0, count($activeUserIds), '?'));
	$stmt         = $pdo->prepare(
		"
        SELECT user_id FROM {$dbPrefix}user_profiles
        WHERE user_id IN ($placeholders)
        AND profile_key = 'joomlatoken.enabled'
        AND profile_value = '1'
    "
	);
	$stmt->execute($activeUserIds);
	$tokenEnabledUserIds = array_column($stmt->fetchAll(), 'user_id');

	if (empty($tokenEnabledUserIds))
	{
		throw new Exception('No users with API token enabled found');
	}

	// Get the token seed
	$placeholders = implode(',', array_fill(0, count($tokenEnabledUserIds), '?'));
	$stmt         = $pdo->prepare(
		"
        SELECT user_id, profile_value FROM {$dbPrefix}user_profiles
        WHERE user_id IN ($placeholders)
        AND profile_key = 'joomlatoken.token'
        LIMIT 1
    "
	);
	$stmt->execute($tokenEnabledUserIds);
	$tokenRecord = $stmt->fetch();

	if (!$tokenRecord)
	{
		throw new Exception('No API token seed found');
	}

	$userId    = $tokenRecord['user_id'];
	$tokenSeed = $tokenRecord['profile_value'];

	// Calculate the token
	$token = hash_hmac('sha256', base64_decode($tokenSeed), $secret);

	// Output JSON
	echo json_encode(['token' => base64_encode("sha256:$userId:$token")]);

}
catch (Exception $e)
{
	echo json_encode(['error' => $e->getMessage()]);
	exit(1);
}
