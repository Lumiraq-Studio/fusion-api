import {BaseEntity, Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import {Warehouse} from './warehouse.schema';
import {ProductVariant} from "./product-variant.schema";
import {ProductMaterial} from "./product-materials.schema";

@Entity('tbl_product')
export class Product extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:true})
    productReference: string;

    @Column()
    name: string;

    @Column()
    description: string;

    @ManyToOne(() => Warehouse, (warehouse) => warehouse.products, { nullable: false })
    warehouse: Warehouse;

    @OneToMany(() => ProductVariant, (variant) => variant.product)
    variants: ProductVariant[];

    @OneToMany(() => ProductMaterial, pm => pm.product)
    materials: ProductMaterial[];

    @Column()
    createdBy: string;

    @Column({ nullable: true })
    updatedBy: string;
}
