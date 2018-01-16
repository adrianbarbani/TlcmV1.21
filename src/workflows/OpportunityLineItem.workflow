<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Actualizar_valor</fullName>
        <field>Campo_para_sumar_en_oportunidad__c</field>
        <formula>FCV__c</formula>
        <name>Actualizar valor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_valor_cargo_x_unica_vez</fullName>
        <description>Copia el valor de la formula, cargo por unica vez total al campo cargo por unica vez total sumable para que luego esta informacion pueda aparecer en las oportunidades.</description>
        <field>Cargo_por_nica_vez_total_sumable__c</field>
        <formula>Cargo_por_unica_vez_total__c</formula>
        <name>Actualizar valor cargo x unica vez</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_valor_totales_por_mes</fullName>
        <field>Cargo_totales_por_mes_Total_sumable__c</field>
        <formula>Cargos_Totales_por_Mes__c</formula>
        <name>Actualizar valor totales por mes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Igualar Valores FCV</fullName>
        <actions>
            <name>Actualizar_valor</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Actualizar_valor_cargo_x_unica_vez</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Actualizar_valor_totales_por_mes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
