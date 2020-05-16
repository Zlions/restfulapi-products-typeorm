import {Application} from "express";
import {CustomerService} from "../services/customer.service";

export class CustomerController{
    customer_service: CustomerService;
    constructor(private app: Application){
        this.customer_service = new CustomerService();
        this.routes();
    }
    private routes(){
        
        this.app.route("/customer/:id").get(this.customer_service.getInformation);
        this.app.route("/customers/run_sp").get(this.customer_service.runsp);
    }
}