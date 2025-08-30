import {BaseEntity, Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn} from 'typeorm';
import {Status, StockStatus} from "../utils/enums/status.enum";
import {Material} from "./material.schema";


@Entity('tbl_material_stock')
export class MaterialStock extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({type: 'enum', enum: StockStatus, default: StockStatus.IN_STOCK})
    status: StockStatus.IN_STOCK;

    @Column()
    addedDate: string;

    @Column({type: "decimal", precision: 10, scale: 2})
    price: number;

    @Column({default: 0})
    quantity: number;

    @Column({default: 0})
    actualQuantity: string;

    @Column({default: 0})
    availableQuantity: string;

    @Column()
    unit: string;

    @Column()
    createdBy: string;

    @Column({nullable: true})
    updatedBy: string;

    @Column({nullable: true})
    createdAt: Date;

    @Column({ nullable: true, type: 'time' })
    createdTime: string;

    @UpdateDateColumn({nullable: true})
    updatedAt: Date;

    @ManyToOne(() => Material, (material) => material.stocks)
    material: Material;

}

