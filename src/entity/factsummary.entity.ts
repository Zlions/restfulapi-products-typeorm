import {ViewEntity,ViewColumn} from "typeorm";

@ViewEntity({schema:"example", database:"ingresos", name:"view_fact_summary"})
export class FactSummary{
    @ViewColumn()
    CustomerID: number
    @ViewColumn()
    CustomerName: string
    @ViewColumn()
    SupplierID: number
    @ViewColumn()
    SupplierName: string
    @ViewColumn()
    mes: number
    @ViewColumn()
    year: number
    @ViewColumn()
    total: number
    @ViewColumn()
    SuperoPromedio: number
    @ViewColumn()
    PorcentajeVentaMensual: number
}

export interface IFactSummary{    
    CustomerID: number;
    CustomerName: string;
    SupplierID: number;
    SupplierName: string;
    mes: number;
    year: number;
    total: number;
    SuperoPromedio: number;
    PorcentajeVentaMensual: number;
}

export interface IResult{
    Successed: number
}