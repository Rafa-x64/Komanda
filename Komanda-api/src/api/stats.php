<?php
// 1. Headers Sagrados (CORS)
// Sin esto, Vue (puerto 5173) y PHP (puerto 8000) se pelearán.
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 2. Simulación de "Lógica de Negocio Pesada"
// Aquí conectarías a Postgres, harías queries locos, etc.
$metrics = [
    "total_orders" => 145,
    "avg_prep_time" => "12m 30s",
    "top_dish" => "Hamburguesa Doble Queso",
    "efficiency_score" => 98.5k
];

// 3. Respuesta JSON Limpia (Estándar JSend)
echo json_encode(
    [
        "status" => "success",
        "data" => $metrics
    ]
);
