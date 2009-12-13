# ♚ Throne

The king is here - on his couch, covered in rubies.

Simple library for working with CouchDB

## Basic Usage

Create a database object to work with. Will create the DB if it doesn't exist

    @db = Throne::Database.new('http://localhost:5984/throne-test')
    # if you don't want to create the DB if it doesn't exist:
    @db = Throne::Database.new('http://localhost:5984/throne-test', false)

Save a new document

    id = @db.save({:document_title => 'New Document', :documents => 'are just a hash')
    id_of_document_saved = id
    revision_of_document_saved = id.revision

Get a document

    doc = @db.get(document_id)
    # with revision
    doc = @db.get(document_id, revision)

Save an existing document

    id = @db.save(existing_document_loaded_from_db)
    new_revision = id.revision

Delete a document

    @db.delete(document_id_or_document_object)

Run a design document/function

    res = @db.function('_design/DesignDoc/_view/viewname')
    res
    => An array of documents
    res.offset
    => couchdb offset data

    # with parameters
    @db.function('_design/DD/_list/listname/viewname', :key => ab..fg, :xyz => 7)
    => An array of documents

    # Iterator Method
    @db.function('_design/DesignDoc/_view/viewname') do |doc|
      #invoked for each document
      p doc
    end

    # All documents
    @db.function('_all_docs')
    => All docs in the database

Delete the database

    @db.delete_database

Create the database
  
    @db.create_database

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

# Copyright

Copyright (c) 2009 Lincoln Stoll, Ben Schwarz. See LICENSE for details.
