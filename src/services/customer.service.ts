import {Request, Response} from "express";
import {getConnection} from "typeorm";
import {IFactSummary,FactSummary,IResult} from "../entity/factsummary.entity";


export class CustomerService{   

    public async getInformation(req:Request, res: Response){
        const customers: FactSummary[] = await getConnection().getRepository(FactSummary).find({ where: {CustomerID: req.params.id} });
        res.status(200).json(customers);
    }

    public async runsp(req: Request, res: Response){        
        const result: any = await getConnection().query("EXEC example.FILL_FACT_SUMMARY");
        res.status(200).json(result);
    }

    

}