/**
 * @description: AbstractRepository
 * Utilizado método de AbstractRepoitory inspirado no Eduardo Carvalho - Salesforce Apex (trecho codificado a partir da classe AbstractRepository do livro - Implemente soluções com padrões e técnicas de orientações a objetos)
 * @author: Reirysson Costa
 */
public abstract class AbstractRepository {
    
    virtual
    public SObject save (SObject aggregate) {

        if (aggregate == null) return null;

        upsert aggregate;

        return aggregate;
    }

    virtual
    public List<SObject> save (List<SObject> aggregates) {

        if (aggregates == null) return new List<SObject>();

        if (aggregates.isEmpty()) return aggregates;

        upsert aggregates;

        return aggregates;

    }
    
}