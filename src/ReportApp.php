<?php

namespace App\src;

class ReportApp
{
    private array $orders;
    private string $filePath;
    private array $stats = [
        'total_paid' => 0,
        'count' => 0,
        'avg_amount' => 0
    ];

    public function __construct(array $orders, string $file) {
        $this->orders = $orders;
        $this->filePath = $file;
        echo "Start report" . PHP_EOL;
    }

    public function process(): void {
        $validAmounts = [];

        foreach ($this->orders as $order) {
            if (isset($order['status'], $order['amount'])
                && $order['status'] === 'paid'
                && $order['amount'] > 0
            ) {
                $this->stats['total_paid'] += $order['amount'];
                $this->stats['count']++;
                $validAmounts[] = $order['amount'];
            }
        }

        if ($this->stats['count'] > 0) {
            $this->stats['avg_amount'] = $this->stats['total_paid'] / $this->stats['count'];
        }
    }

    public function write(): void {
        $txt = "Total paid = " . $this->stats['total_paid'] . PHP_EOL;

        if (file_put_contents($this->filePath, $txt, LOCK_EX) === false) {
            error_log("Помилка: Не вдалося записати звіт у файл {$this->filePath}");
        }
    }

    public function summary(): void {
        echo "Valid orders: " . $this->stats['count'] . PHP_EOL;
        echo "Total paid: " . $this->stats['total_paid'] . PHP_EOL;
        echo "Avg amount: " . $this->stats['avg_amount'] . PHP_EOL;
        echo "File: " . $this->filePath . PHP_EOL;
    }

    public function __destruct() {
        error_log("[" . date('Y-m-d H:i:s') . "] Report generation finished for {$this->filePath}");
    }
}
