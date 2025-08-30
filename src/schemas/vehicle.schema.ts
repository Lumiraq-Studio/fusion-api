import {BaseEntity, Column, Entity, ManyToOne, PrimaryGeneratedColumn} from 'typeorm';
import {SalesRep} from "./sales_rep.schema";


@Entity('tbl_vehicle')
export class Vehicle extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    registrationNo: string;

    @Column()
    type: string;

    @Column()
    capacity: number;

    @ManyToOne(() => SalesRep, (salesRep) => salesRep.vehicles)
    salesRep: SalesRep;
}
