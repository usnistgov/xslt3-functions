<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns prefix="x" uri="http://www.jenitennison.com/xslt/xspec"/>

    <sch:pattern>
        <sch:rule context="*[exists(@href)]">
            <sch:assert test="resolve-uri(@href, base-uri(.)) => doc-available()">No document found at <sch:value-of select="@href"/></sch:assert>
        </sch:rule>
    </sch:pattern>
        
</sch:schema>