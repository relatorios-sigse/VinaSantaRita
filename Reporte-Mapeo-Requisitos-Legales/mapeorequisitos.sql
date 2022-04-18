SELECT

/**
Creación:
https://vinasantarita.softexpert.com/
2022-04-18. Andrés Del Río. Consultas estándar de mapeo de requisitos (vista Sintética), e inclusión
de atributos Norma Aplicable y Organismo que la dicta.
Versión: 2.1.7.112
Panel de análisis: REPMAPREQ-Reporte Mapeo de Requisitos Legales
Modificaciones:
<AAAA-MM-DD>. Autor. Descripción
**/

(SELECT ADATTRIBVALUE.NMATTRIBUTE
        FROM GNASSOCATTRIB 
             LEFT OUTER JOIN ADATTRIBUTE ON GNASSOCATTRIB.CDATTRIBUTE = ADATTRIBUTE.CDATTRIBUTE
             LEFT OUTER JOIN ADATTRIBVALUE ON ADATTRIBVALUE.CDATTRIBUTE= GNASSOCATTRIB.CDATTRIBUTE AND ADATTRIBVALUE.CDVALUE  = GNASSOCATTRIB.CDVALUE
     WHERE GNASSOCATTRIB.CDASSOC = RQMABU.CDASSOC AND ADATTRIBUTE.CDATTRIBUTE = 7) AS NORMA_APLICABLE,

(SELECT ADATTRIBVALUE.NMATTRIBUTE
        FROM GNASSOCATTRIB 
             LEFT OUTER JOIN ADATTRIBUTE ON GNASSOCATTRIB.CDATTRIBUTE = ADATTRIBUTE.CDATTRIBUTE
             LEFT OUTER JOIN ADATTRIBVALUE ON ADATTRIBVALUE.CDATTRIBUTE= GNASSOCATTRIB.CDATTRIBUTE AND ADATTRIBVALUE.CDVALUE  = GNASSOCATTRIB.CDVALUE
     WHERE GNASSOCATTRIB.CDASSOC = RQMABU.CDASSOC AND ADATTRIBUTE.CDATTRIBUTE = 8) AS ORGANISMO_QUE_DICTA,

        RQMAPREV.CDMAPPING,
        RQMAPREV.CDREVISION,
        REQUIREMENTS.REQMODEL AS REQMODEL,
        REQUIREMENTS.CDREQUIREMENT,
        REQUIREMENTS.CDREVISION AS CDREQUIREMENTREV,
        REQUIREMENTS.IDREQUIREMENT,
        REQUIREMENTS.NMREQUIREMENT,
        REQUIREMENTS.CDREQUIREMENTBASE,
        GGT.IDGENTYPE,
        REQUIREMENTS.IDREQUIREMENT || ' - ' || REQUIREMENTS.NMREQUIREMENT AS REQUIREMENT,
        FATHER.IDREQUIREMENT || ' - ' || FATHER.NMREQUIREMENT AS REQPARENT,
        RQMAPREV.IDMAPPING || ' - ' || RQMAPREV.NMMAPPING AS MAPPING,
        RQMAPREV.FGOBJECTMAP,
        RQMAPREV.CDOBJECT,
        RQMAPREV.CDOBJECTREV,
        RQMAPREV.CDSUPPLIER,
        RQMAPREV.CDBUSINESSUNIT,
        REQUIREMENTS.CDASSOC,
        MAPPINGANALYSIS.CDASSOC AS CDASSOC_MAP,
        MAPPINGANALYSIS.DSJUSTIFY,
        GGT.CDGENTYPE,
        RQC.QTAPPLYTOTAL,
        RQC.VLIMPLEMENTED,
        RQC.QTAPPLY,
        RQC.CDEVALRESULTUSED,
        GNERU.VLEVALRESULT,
        GNER.NMEVALRESULT,
        GNER.IDCOLOR,
        ADBU.CDDEPARTMENT,
        ADBU.IDDEPARTMENT,
        ADBU.NMDEPARTMENT,
        1 AS HAS_MAPPING,
        OBJ.IDOBJECT,
        OBJ.NMOBJECT,
        OBJ.FGAPPLICATION,
        ADC.IDCOMMERCIAL,
        ADC.NMCOMPANY,
        MAP_AREA.QTD_AREA AS ASSOC_AREA,
        (SELECT
            COUNT(1) 
        FROM
            RQMAPPINGANALYSIS 
        INNER JOIN
            RQMAPPINGREVISION 
                ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
        INNER JOIN
            RICONTROLANALYSIS RCA 
                ON RQMAPPINGANALYSIS.CDCONTROLANABASE=RCA.CDCONTROLANABASE 
        INNER JOIN
            GNASSOCCONTROLANA GNACA 
                ON RCA.CDCONTROLANALYSIS=GNACA.CDCONTROLANALYSIS 
        INNER JOIN
            RIPLAN RP 
                ON GNACA.CDPLAN=RP.CDPLAN 
                AND GNACA.CDREVISION=RP.CDREVISION 
        WHERE
            RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
            AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
            AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
            AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
            AND RQMAPPINGREVISION.FGCURRENT=1 
            AND RQMAPPINGREVISION.FGREVSTATUS=1 
            AND NOT EXISTS (
                SELECT
                    1 
                FROM
                    RQREQUIREMENT 
                WHERE
                    CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
            ) 
            AND RP.FGCURRENT=1 
            AND GNACA.FGCONTROLASSOCTYPE=1
        ) AS QTCONTROL, (
            SELECT
                COUNT(1) 
            FROM
                RQMAPPINGANALYSIS 
            INNER JOIN
                RQMAPPINGREVISION 
                    ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
            INNER JOIN
                PMPROCESS 
                    ON PMPROCESS.CDPROC=RQMAPPINGANALYSIS.CDPROCESS 
            WHERE
                RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                AND RQMAPPINGREVISION.FGCURRENT=1 
                AND RQMAPPINGREVISION.FGREVSTATUS=1 
                AND NOT EXISTS (
                    SELECT
                        1 
                    FROM
                        RQREQUIREMENT 
                    WHERE
                        CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
                )
            ) AS QTPROC, (
                SELECT
                    (SELECT
                        COUNT(1) 
                    FROM
                        RQMAPPINGANALYSIS 
                    INNER JOIN
                        RQMAPPINGREVISION 
                            ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
                    INNER JOIN
                        RICONTROLANALYSIS RCA 
                            ON RQMAPPINGANALYSIS.CDCONTROLANABASE=RCA.CDCONTROLANABASE 
                    INNER JOIN
                        GNASSOCCONTROLANA GNACA 
                            ON RCA.CDCONTROLANALYSIS=GNACA.CDCONTROLANALYSIS 
                    INNER JOIN
                        RIPLAN RP 
                            ON GNACA.CDPLAN=RP.CDPLAN 
                            AND GNACA.CDREVISION=RP.CDREVISION 
                    INNER JOIN
                        RIRISKANALYSIS 
                            ON GNACA.CDASSOC=RIRISKANALYSIS.CDASSOC 
                    WHERE
                        RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                        AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                        AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                        AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                        AND RQMAPPINGREVISION.FGCURRENT=1 
                        AND RQMAPPINGREVISION.FGREVSTATUS=1 
                        AND NOT EXISTS (
                            SELECT
                                1 
                            FROM
                                RQREQUIREMENT 
                            WHERE
                                CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
                        ) 
                        AND RP.FGCURRENT=1 
                        AND GNACA.FGCONTROLASSOCTYPE=1
                    ) + (
                        SELECT
                            COUNT(1) 
                        FROM
                            RQMAPPINGANALYSIS 
                        INNER JOIN
                            RQMAPPINGREVISION 
                                ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
                        INNER JOIN
                            RIRISKANALYSIS RRA 
                                ON RQMAPPINGANALYSIS.CDRISKANABASE=RRA.CDRISKANABASE 
                        INNER JOIN
                            GNASSOCRISKANA GNARA 
                                ON RRA.CDRISKANALYSIS=GNARA.CDRISKANALYSIS 
                        INNER JOIN
                            RIPLAN RP 
                                ON GNARA.CDPLAN=RP.CDPLAN 
                                AND GNARA.CDREVISION=RP.CDREVISION 
                        WHERE
                            RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                            AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                            AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                            AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                            AND RQMAPPINGREVISION.FGCURRENT=1 
                            AND RQMAPPINGREVISION.FGREVSTATUS=1 
                            AND NOT EXISTS (
                                SELECT
                                    1 
                                FROM
                                    RQREQUIREMENT 
                                WHERE
                                    CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
                            ) 
                            AND RP.FGCURRENT=1 
                            AND GNARA.FGRISKASSOCTYPE=1
                        )
                ) AS QTRISK, (
                    SELECT
                        COUNT(1) 
                    FROM
                        RQMAPPINGANALYSIS 
                    INNER JOIN
                        RQMAPPINGREVISION 
                            ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
                    INNER JOIN
                        GNASSOCATTACH GNAT 
                            ON GNAT.CDASSOC=RQMAPPINGANALYSIS.CDASSOC 
                    WHERE
                        RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                        AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                        AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                        AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                        AND RQMAPPINGREVISION.FGCURRENT=1 
                        AND RQMAPPINGREVISION.FGREVSTATUS=1 
                        AND NOT EXISTS (
                            SELECT
                                1 
                            FROM
                                RQREQUIREMENT 
                            WHERE
                                CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
                        ) 
                        AND RQMAPPINGANALYSIS.CDBUSINESSUNIT IS NOT NULL
                    ) AS QTATTACH_MAP, (
                        SELECT
                            COUNT(1) 
                        FROM
                            RQMAPPINGANALYSIS 
                        INNER JOIN
                            RQMAPPINGREVISION 
                                ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
                        INNER JOIN
                            GNASSOCDOCUMENT GNAD 
                                ON GNAD.CDASSOC=RQMAPPINGANALYSIS.CDASSOC 
                        WHERE
                            RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                            AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                            AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                            AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                            AND RQMAPPINGREVISION.FGCURRENT=1 
                            AND RQMAPPINGREVISION.FGREVSTATUS=1 
                            AND NOT EXISTS (
                                SELECT
                                    1 
                                FROM
                                    RQREQUIREMENT 
                                WHERE
                                    CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
                            ) 
                            AND RQMAPPINGANALYSIS.CDBUSINESSUNIT IS NOT NULL
                        ) AS QTDOC_MAP, (
                            SELECT
                                COUNT(1) 
                            FROM
                                RQMAPPINGANALYSIS 
                            INNER JOIN
                                RQMAPPINGREVISION 
                                    ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
                            INNER JOIN
                                GNASSOCWORKFLOW GNAE 
                                    ON GNAE.CDASSOC=RQMAPPINGANALYSIS.CDASSOC 
                            WHERE
                                RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                                AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                                AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                                AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                                AND RQMAPPINGREVISION.FGCURRENT=1 
                                AND RQMAPPINGREVISION.FGREVSTATUS=1 
                                AND NOT EXISTS (
                                    SELECT
                                        1 
                                    FROM
                                        RQREQUIREMENT 
                                    WHERE
                                        CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
                                ) 
                                AND RQMAPPINGANALYSIS.CDBUSINESSUNIT IS NOT NULL
                            ) AS QTEVENT_MAP, (
                                SELECT
                                    COUNT(1) 
                                FROM
                                    RQMAPPINGANALYSIS 
                                INNER JOIN
                                    RQMAPPINGREVISION 
                                        ON RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMAPPINGREVISION.CDREVISION 
                                INNER JOIN
                                    GNASSOCACTIONPLAN GNACT 
                                        ON GNACT.CDASSOC=RQMAPPINGANALYSIS.CDASSOC 
                                WHERE
                                    RQMAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                                    AND RQMAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                                    AND RQMAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                                    AND RQMAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                                    AND RQMAPPINGREVISION.FGCURRENT=1 
                                    AND RQMAPPINGREVISION.FGREVSTATUS=1 
                                    AND NOT EXISTS (
                                        SELECT
                                            1 
                                        FROM
                                            RQREQUIREMENT 
                                        WHERE
                                            CDREQUIREMENTOWNER=REQUIREMENTS.CDREQUIREMENT
                                    ) 
                                    AND RQMAPPINGANALYSIS.CDBUSINESSUNIT IS NOT NULL
                                ) AS QTACTPLAN_MAP, GGTR.IDGENTYPE || ' - ' || GGTR.NMGENTYPE AS IDNM_GENTYPE, ADBU.IDDEPARTMENT || ' - ' || ADBU.NMDEPARTMENT AS BUSINESSUNIT, (
                                    CASE 
                                        WHEN MAP_AREA.QTD_AREA > 1 THEN CAST(MAP_AREA.QTD_AREA AS VARCHAR(255)) || ' ' || '#{102519}' 
                                        WHEN MAP_AREA.QTD_AREA=1 THEN (SELECT
                                            ADAREA.IDDEPARTMENT || ' - ' || ADAREA.NMDEPARTMENT AS AREA_NAME 
                                        FROM
                                            ADDEPARTMENT ADAREA 
                                        INNER JOIN
                                            RQMAPPINGDEPT RQDEPT 
                                                ON ADAREA.CDDEPARTMENT=RQDEPT.CDDEPARTMENT 
                                        WHERE
                                            MAP_AREA.CDMAPPING=RQDEPT.CDMAPPING 
                                            AND MAP_AREA.CDMAPPINGREVISION=RQDEPT.CDMAPPINGREVISION) 
                                        ELSE '' 
                                    END
                                ) AS QTD_AREA, (
                                    CASE 
                                        WHEN RQMABU.FGAPPLY=1 THEN '#{100092}' 
                                        ELSE '#{100093}' 
                                    END
                                ) AS FGAPPLY, RQMAPREV.IDMAPPING, RQMAPREV.NMMAPPING, FATHER.IDREQUIREMENT AS IDFATHER, PARENT.IDREQUIREMENT AS IDPARENT, (
                                    CASE 
                                        WHEN RQMAPREV.CDOBJECT IS NOT NULL THEN OBJ.IDOBJECT || ' - ' || OBJ.NMOBJECT 
                                        ELSE '' 
                                    END
                                ) AS OBJECT_NAME, (
                                    CASE 
                                        WHEN RQMAPREV.CDSUPPLIER IS NOT NULL THEN ADC.IDCOMMERCIAL || ' - ' || ADC.NMCOMPANY 
                                        ELSE '' 
                                    END
                                ) AS SUPPLIER, (
                                    CASE 
                                        WHEN RQMAPREV.FGOBJECTMAP=1 THEN '#{200978}' 
                                        WHEN RQMAPREV.FGOBJECTMAP=2 THEN '#{219839}' 
                                        WHEN RQMAPREV.FGOBJECTMAP=3 THEN '#{309328}' 
                                        WHEN RQMAPREV.FGOBJECTMAP=4 THEN '#{309329}' 
                                        WHEN RQMAPREV.FGOBJECTMAP=5 THEN '#{309652}' 
                                        WHEN RQMAPREV.FGOBJECTMAP=6 THEN '#{309653}' 
                                        WHEN RQMAPREV.FGOBJECTMAP=7 THEN '#{309654}' 
                                    END
                                ) AS MAPPING_SCOPE 
                            FROM
                                RQMAPPINGREVISION RQMAPREV 
                            INNER JOIN
                                GNREVISION GNR 
                                    ON GNR.CDREVISION=RQMAPREV.CDREVISION 
                            INNER JOIN
                                RQMAPPINGCONFIG RQMAPCFG 
                                    ON RQMAPCFG.CDGENTYPE=RQMAPREV.CDGENTYPE 
                            INNER JOIN
                                GNGENTYPE GGTM 
                                    ON GGTM.CDGENTYPE=RQMAPCFG.CDGENTYPE 
                            INNER JOIN
                                RQTYPE RQT 
                                    ON RQT.CDGENTYPE=RQMAPCFG.CDREQTYPE 
                            INNER JOIN
                                GNGENTYPE GGTR 
                                    ON GGTR.CDGENTYPE=RQT.CDGENTYPE 
                                    AND GGTR.FGACTIVE=1 
                            INNER JOIN
                                RQMAPPINGREQM RQMR 
                                    ON RQMR.CDMAPPING=RQMAPREV.CDMAPPING 
                                    AND RQMR.CDMAPPINGREVISION=RQMAPREV.CDREVISION 
                            INNER JOIN
                                (
                                    SELECT
                                        2 AS REQMODEL,
                                        GUIDE.CDREQUIREMENT,
                                        GUIDE.CDREVISION,
                                        GUIDE.IDREQUIREMENT,
                                        GUIDE.NMREQUIREMENT,
                                        GUIDE.CDREQUIREMENTOWNER,
                                        GUIDE.CDREQUIREMENTBASE,
                                        GUIDE.CDASSOC,
                                        GUIDE.NRORDER,
                                        REFG.IDREQUIREMENT AS NMREF 
                                    FROM
                                        RQREQUIREMENT GUIDE 
                                    INNER JOIN
                                        RQREQUIREMENT REFG 
                                            ON GUIDE.CDREQUIREMENT=REFG.CDREQUIREMENT 
                                            AND GUIDE.CDREVISION=REFG.CDREVISION 
                                    WHERE
                                        GUIDE.CDREQUIREMENTOWNER IS NOT NULL 
                                        AND EXISTS (
                                            SELECT
                                                1 
                                            FROM
                                                RQREQUIREMENT 
                                            WHERE
                                                RQREQUIREMENT.CDREQUIREMENTOWNER=GUIDE.CDREQUIREMENT
                                        ) 
                                    UNION
                                    ALL SELECT
                                        3 AS REQMODEL,
                                        LEAF.CDREQUIREMENT,
                                        LEAF.CDREVISION,
                                        LEAF.IDREQUIREMENT,
                                        LEAF.NMREQUIREMENT,
                                        LEAF.CDREQUIREMENTOWNER,
                                        LEAF.CDREQUIREMENTBASE,
                                        LEAF.CDASSOC,
                                        LEAF.NRORDER,
                                        REFL.IDREQUIREMENT AS NMREF 
                                    FROM
                                        RQREQUIREMENT LEAF 
                                    INNER JOIN
                                        RQREQUIREMENT REFL 
                                            ON REFL.CDREQUIREMENT=LEAF.CDREQUIREMENT 
                                            AND LEAF.CDREVISION=REFL.CDREVISION 
                                    WHERE
                                        LEAF.CDREQUIREMENTOWNER IS NOT NULL 
                                        AND NOT EXISTS (
                                            SELECT
                                                1 
                                            FROM
                                                RQREQUIREMENT 
                                            WHERE
                                                RQREQUIREMENT.CDREQUIREMENTOWNER=LEAF.CDREQUIREMENT
                                        )
                                    ) REQUIREMENTS 
                                        ON REQUIREMENTS.CDREQUIREMENTBASE=RQMR.CDREQUIREMENT 
                                        AND REQUIREMENTS.CDREVISION=RQMR.CDREQUIREMENTREV 
                                INNER JOIN
                                    RQREVISION RQREV 
                                        ON REQUIREMENTS.CDREVISION=RQREV.CDREVISION 
                                INNER JOIN
                                    RQTYPE RQREQT 
                                        ON RQREQT.CDGENTYPE=RQREV.CDGENTYPE 
                                INNER JOIN
                                    GNGENTYPE GGT 
                                        ON GGT.CDGENTYPE=RQREV.CDGENTYPE 
                                INNER JOIN
                                    ADDEPARTMENT ADBU 
                                        ON RQMAPREV.CDBUSINESSUNIT=ADBU.CDDEPARTMENT 
                                INNER JOIN
                                    RQMAPPINGANALYSIS MAPPINGANALYSIS 
                                        ON MAPPINGANALYSIS.CDBUSINESSUNIT IS NOT NULL 
                                        AND MAPPINGANALYSIS.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                                        AND MAPPINGANALYSIS.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                                        AND MAPPINGANALYSIS.CDMAPPING=RQMR.CDMAPPING 
                                        AND MAPPINGANALYSIS.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                                LEFT OUTER JOIN
                                    RQMAPCOVERAGE RQC 
                                        ON RQC.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                                        AND RQC.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                                        AND RQC.CDMAPPING=RQMR.CDMAPPING 
                                        AND RQC.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                                LEFT OUTER JOIN
                                    RQREQUIREMENT FATHER 
                                        ON FATHER.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENTBASE 
                                        AND FATHER.CDREVISION=REQUIREMENTS.CDREVISION 
                                LEFT OUTER JOIN
                                    GNEVALRESULTUSED GNERU 
                                        ON GNERU.CDEVALRESULTUSED=RQC.CDEVALRESULTUSED 
                                LEFT OUTER JOIN
                                    GNEVALRESULT GNER 
                                        ON GNERU.CDEVALRESULT=GNER.CDEVALRESULT 
                                LEFT OUTER JOIN
                                    (
                                        SELECT
                                            CDMAPPING,
                                            CDMAPPINGREVISION,
                                            COUNT(1) AS QTD_AREA 
                                        FROM
                                            RQMAPPINGDEPT 
                                        GROUP BY
                                            CDMAPPING,
                                            CDMAPPINGREVISION
                                    ) MAP_AREA 
                                        ON MAP_AREA.CDMAPPING=RQMAPREV.CDMAPPING 
                                        AND MAP_AREA.CDMAPPINGREVISION=RQMAPREV.CDREVISION 
                                LEFT OUTER JOIN
                                    OBOBJECT OBJ 
                                        ON OBJ.CDOBJECT=RQMAPREV.CDOBJECT 
                                        AND OBJ.CDREVISION=RQMAPREV.CDOBJECTREV 
                                LEFT OUTER JOIN
                                    GNSUPPLIER GNSUP 
                                        ON GNSUP.CDSUPPLIER=RQMAPREV.CDSUPPLIER 
                                LEFT OUTER JOIN
                                    ADCOMPANY ADC 
                                        ON ADC.CDCOMPANY=GNSUP.CDSUPPLIER 
                                LEFT OUTER JOIN
                                    RQREQUIREMENT PARENT 
                                        ON PARENT.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENTOWNER 
                                        AND PARENT.CDREVISION=REQUIREMENTS.CDREVISION 
                                LEFT OUTER JOIN
                                    RQMAPPINGANALYSIS RQMABU 
                                        ON RQMABU.CDREQUIREMENT=REQUIREMENTS.CDREQUIREMENT 
                                        AND RQMABU.CDREQUIREMENTREV=REQUIREMENTS.CDREVISION 
                                        AND RQMABU.CDMAPPING=RQMR.CDMAPPING 
                                        AND RQMABU.CDMAPPINGREVISION=RQMR.CDMAPPINGREVISION 
                                        AND RQMABU.CDDEPARTMENT IS NULL 
                                WHERE
                                    RQMAPREV.FGCURRENT=1 
                                    AND GNR.FGSTATUS=6 
                                    AND (
                                        RQREQT.CDTYPEROLE IS NULL 
                                        OR EXISTS (
                                            SELECT
                                                NULL 
                                            FROM
                                                (SELECT
                                                    CHKUSRPERMTYPEROLE.CDTYPEROLE AS CDTYPEROLE,
                                                    CHKUSRPERMTYPEROLE.CDUSER 
                                                FROM
                                                    (SELECT
                                                        PM.FGPERMISSIONTYPE,
                                                        PM.CDUSER,
                                                        PM.CDTYPEROLE 
                                                    FROM
                                                        GNUSERPERMTYPEROLE PM 
                                                    WHERE
                                                        1=1 
                                                        AND PM.CDUSER <> -1 
                                                        AND PM.CDPERMISSION=5 /* Nao retirar este comentario */
                                                    UNION
                                                    ALL SELECT
                                                        PM.FGPERMISSIONTYPE,
                                                        US.CDUSER AS CDUSER,
                                                        PM.CDTYPEROLE 
                                                    FROM
                                                        GNUSERPERMTYPEROLE PM CROSS 
                                                    JOIN
                                                        ADUSER US 
                                                    WHERE
                                                        1=1 
                                                        AND PM.CDUSER=-1 
                                                        AND US.FGUSERENABLED=1 
                                                        AND PM.CDPERMISSION=5
                                                ) CHKUSRPERMTYPEROLE 
                                            GROUP BY
                                                CHKUSRPERMTYPEROLE.CDTYPEROLE,
                                                CHKUSRPERMTYPEROLE.CDUSER 
                                            HAVING
                                                MAX(CHKUSRPERMTYPEROLE.FGPERMISSIONTYPE)=1) CHKPERMTYPEROLE 
                                        WHERE
                                            CHKPERMTYPEROLE.CDTYPEROLE=RQREQT.CDTYPEROLE 
                                            AND (
                                                CHKPERMTYPEROLE.CDUSER=1 
                                                OR 1=-1
                                            )
                                        ))