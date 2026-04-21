<?php

require_once 'src/ReportApp.php';

use App\src\ReportApp;

$orders = [
    ["id" => 1, "user" => "Ivan", "amount" => 100, "status" => "paid"],
    ["id" => 2, "user" => "Oksana", "amount" => -50, "status" => "paid"],
    ["id" => 3, "user" => "Ivan", "amount" => 200, "status" => "pending"],
    ["id" => 4, "user" => "Petro", "amount" => 300, "status" => "paid"],
];

$app = new ReportApp($orders, "report.txt");
$app->process();
$app->write();
$app->summary();