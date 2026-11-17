-- ===============================================================================
-- PROJECT 5: POST-HARVEST FOOD LOSS & WASTE (FLW) & CARBON EMISSION DIAGNOSTIC
-- SQL WAREHOUSE ANALYTICAL QUERIES (SQLite Compatible)
-- ===============================================================================

-- 1. Supply Chain Node Loss & Carbon Emission Audit
-- Ranks supply chain nodes by total physical spoilage tonnage and embodied GHG emissions.
SELECT 
    supply_chain_node,
    COUNT(shipment_id) AS total_shipments,
    ROUND(SUM(initial_tonnage), 2) AS total_initial_tonnage,
    ROUND(SUM(spoilage_tonnage), 2) AS total_spoilage_tonnage,
    ROUND(AVG(physical_loss_pct), 2) AS avg_loss_pct,
    ROUND(SUM(financial_loss_inr), 2) AS total_financial_loss_inr,
    ROUND(SUM(embodied_ghg_loss_ton_co2e), 2) AS total_ghg_loss_ton_co2e,
    RANK() OVER (ORDER BY SUM(financial_loss_inr) DESC) AS financial_loss_rank
FROM shipment_loss_logs
GROUP BY supply_chain_node
ORDER BY financial_loss_rank;

-- 2. Crop-Wise Spoilage & Scope 3 Carbon Intensity Ranking
-- Evaluates perishable crops by loss severity and embodied carbon footprint.
SELECT 
    crop_name,
    COUNT(shipment_id) AS batch_count,
    ROUND(SUM(initial_tonnage), 2) AS initial_tonnage,
    ROUND(SUM(spoilage_tonnage), 2) AS spoilage_tonnage,
    ROUND(AVG(physical_loss_pct), 2) AS avg_spoilage_pct,
    ROUND(SUM(financial_loss_inr), 2) AS total_financial_loss_inr,
    ROUND(SUM(embodied_ghg_loss_ton_co2e), 2) AS total_ghg_loss_ton_co2e,
    ROUND(SUM(financial_loss_inr) / SUM(spoilage_tonnage), 2) AS loss_cost_per_spoil_ton_inr,
    DENSE_RANK() OVER (ORDER BY SUM(embodied_ghg_loss_ton_co2e) DESC) AS carbon_loss_rank
FROM shipment_loss_logs
GROUP BY crop_name
ORDER BY carbon_loss_rank;

-- 3. High-Temperature Thermal Breach Analysis (> 32°C Ambient or > 12°C Reefer)
-- Isolates shipments subjected to severe thermal friction causing > 12% loss.
WITH ThermalBreachShipments AS (
    SELECT 
        shipment_id,
        crop_name,
        origin_hub,
        supply_chain_node,
        ambient_temp_c,
        reefer_temp_c,
        physical_loss_pct,
        financial_loss_inr,
        embodied_ghg_loss_ton_co2e,
        CASE 
            WHEN ambient_temp_c > 35.0 AND reefer_temp_c > 15.0 THEN 'Critical Thermal Breakdown'
            WHEN ambient_temp_c > 30.0 AND reefer_temp_c > 10.0 THEN 'Moderate Thermal Stress'
            ELSE 'Controlled Ambient'
        END AS thermal_risk_tier
    FROM shipment_loss_logs
)
SELECT 
    thermal_risk_tier,
    COUNT(shipment_id) AS shipment_count,
    ROUND(AVG(physical_loss_pct), 2) AS avg_loss_pct,
    ROUND(SUM(financial_loss_inr), 2) AS total_loss_inr,
    ROUND(SUM(embodied_ghg_loss_ton_co2e), 2) AS total_ghg_ton_co2e
FROM ThermalBreachShipments
GROUP BY thermal_risk_tier
ORDER BY total_loss_inr DESC;

-- 4. CapEx Solar Packhouse Investment ROI & Payback Prioritization
-- Calculates regional loss mitigation potential assuming a 65% loss reduction via solar micro-packhouses.
SELECT 
    origin_hub,
    COUNT(shipment_id) AS total_shipments,
    ROUND(SUM(spoilage_tonnage), 2) AS baseline_spoilage_tonnage,
    ROUND(SUM(financial_loss_inr), 2) AS baseline_financial_loss_inr,
    ROUND(SUM(financial_loss_inr) * 0.65, 2) AS annual_mitigated_savings_inr,
    ROUND(SUM(embodied_ghg_loss_ton_co2e) * 0.65, 2) AS mitigated_ghg_ton_co2e,
    ROUND((1500000.0 / (SUM(financial_loss_inr) * 0.65 / COUNT(shipment_id))) * 12.0, 1) AS est_capex_payback_months
FROM shipment_loss_logs
GROUP BY origin_hub
ORDER BY annual_mitigated_savings_inr DESC;
