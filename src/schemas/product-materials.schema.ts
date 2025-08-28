import {
    BaseEntity,
    BeforeInsert,
    BeforeUpdate,
    Column,
    CreateDateColumn,
    Entity,
    ManyToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';

import { Product } from './product.schema';
import { MaterialStock } from './material-stock.schema';

@Entity('tbl_product_material')
export class ProductMaterial extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    materialDate: string;

    @Column({ type: 'enum', enum: ['used', 'reserved', 'returned'], default: 'used' })
    status: string;

    @Column({ default: 0 })
    productQty: number;

    @Column({ default: 0 })
    materialQty: number;

    @Column('decimal', { precision: 10, scale: 2 })
    pricePerOne: number;

    @Column('decimal', { precision: 10, scale: 2 })
    cost: number;

    @CreateDateColumn({ type: 'datetime', precision: 6 })
    createdAt: Date;

    @UpdateDateColumn({ type: 'datetime', precision: 6, nullable: true })
    updatedAt: Date;

    @ManyToOne(() => Product, product => product.materials, { onDelete: 'CASCADE' })
    product: Product;

    @ManyToOne(() => MaterialStock, { onDelete: 'SET NULL' })
    materialStock: MaterialStock;

    @Column()
    createdBy: string;

    @Column({nullable: true})
    updatedBy: string;

    @Column({ nullable: true, type: 'time' })
    createdTime: string;

    @BeforeInsert()
    @BeforeUpdate()
    calculateCost() {
        this.cost = Number(this.materialQty) * Number(this.pricePerOne);
    }
}
