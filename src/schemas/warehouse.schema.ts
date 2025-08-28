import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    OneToMany,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';
import {Product} from './product.schema';
import {VariantStock} from "./variant-stocks.schema";

@Entity('tbl_warehouse')
export class Warehouse extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    warehouseCode: string;

    @Column()
    warehouseName: string;

    @Column()
    warehouseAddress: string;

    @Column()
    contactPersonName: string;

    @Column()
    contactNo: string;

    @OneToMany(() => Product, (product) => product.warehouse)
    products: Product[];

    @OneToMany(() => VariantStock, (productStock) => productStock.warehouse)
    productStocks: VariantStock[];
    @Column()
    createdBy: string;

    @Column({nullable: true})
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({nullable: true})
    updatedAt: Date;
}
