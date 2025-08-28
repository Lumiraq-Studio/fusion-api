import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    ManyToOne,
    OneToMany,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';
import {Product} from "./product.schema";
import {ShopProductPrice} from "./shop_price.schema";
import {VariantStock} from "./variant-stocks.schema";


@Entity('tbl_product_variant')
export class ProductVariant extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    variantReference: string;

    @ManyToOne(() => Product, (product) => product.variants, { nullable: false })
    product: Product;

    @OneToMany(() => VariantStock, (stock) => stock.variant)
    stocks: VariantStock[];

    @OneToMany(() => ShopProductPrice, (shopVariantPrice) => shopVariantPrice.variant)
    shopPrices: ShopProductPrice[];


    @Column({ type: "decimal", precision: 10, scale: 2 })
    cost: number;

    @Column({ type: "decimal", precision: 10, scale: 2 })
    basePrice: number;

    @Column()
    weight: number;

    @Column()
    unit: string;

    @Column()
    createdBy: string;

    @Column({ nullable: true })
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({ nullable: true })
    updatedAt: Date;
}
